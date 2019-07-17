import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sp_client/widget/rich_text_editor/service/spannable_text.dart';
import 'package:sp_client/widget/rich_text_editor/widget/editable_text.dart';

const double _kHandleSize = 22.0;
const double _kToolbarScreenPadding = 8.0;
const double _kToolbarHeight = 44.0;

final TextSelectionControls customTextSelectionControls =
    _MaterialTextSelectionControls();

class RichTextEditor extends StatefulWidget {
  final TextEditingController controller;
  final SpannableTextController spannableController;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final bool autofocus;
  final TextStyle style;
  final InputDecoration decoration;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final int maxLines;
  final int maxLength;
  final InputCounterWidgetBuilder buildCounter;
  final bool enabled;
  final bool expands;

  bool get selectionEnabled => true;

  RichTextEditor({
    Key key,
    this.controller,
    this.spannableController,
    this.decoration = const InputDecoration(),
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.focusNode,
    this.onTap,
    this.autofocus = false,
    this.style,
    this.maxLines,
    this.maxLength,
    this.buildCounter,
    this.enabled = true,
    this.expands = false,
  }) : super(key: key);

  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  final GlobalKey<SpannableEditableTextState> _editableTextKey =
      GlobalKey<SpannableEditableTextState>();

  SpannableEditableTextState get _editableText => _editableTextKey.currentState;

  TextEditingController _controller;
  TextEditingController get _effectiveController =>
      widget.controller ?? _controller;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _isHovering = false;

  RenderEditable get _renderEditable =>
      _editableTextKey.currentState.renderEditable;

  bool get needsCounter =>
      widget.maxLength != null &&
      widget.decoration != null &&
      widget.decoration.counterText == null;

  bool _shouldShowSelectionToolbar = true;

  InputDecoration _getEffectiveDecoration() {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration =
        (widget.decoration ?? const InputDecoration())
            .applyDefaults(themeData.inputDecorationTheme)
            .copyWith(
              enabled: widget.enabled,
              hintMaxLines: widget.decoration?.hintMaxLines ?? widget.maxLines,
            );

    // No need to build anything if counter or counterText were given directly.
    if (effectiveDecoration.counter != null ||
        effectiveDecoration.counterText != null) return effectiveDecoration;

    // If buildCounter was provided, use it to generate a counter widget.
    Widget counter;
    final int currentLength = _effectiveController.value.text.runes.length;
    if (effectiveDecoration.counter == null &&
        effectiveDecoration.counterText == null &&
        widget.buildCounter != null) {
      final bool isFocused = _effectiveFocusNode.hasFocus;
      counter = Semantics(
        container: true,
        liveRegion: isFocused,
        child: widget.buildCounter(
          context,
          currentLength: currentLength,
          maxLength: widget.maxLength,
          isFocused: isFocused,
        ),
      );
      return effectiveDecoration.copyWith(counter: counter);
    }

    if (widget.maxLength == null)
      return effectiveDecoration; // No counter widget

    String counterText = '$currentLength';
    String semanticCounterText = '';

    // Handle a real maxLength (positive number)
    if (widget.maxLength > 0) {
      // Show the maxLength in the counter
      counterText += '/${widget.maxLength}';
      final int remaining =
          (widget.maxLength - currentLength).clamp(0, widget.maxLength);
      semanticCounterText =
          localizations.remainingTextFieldCharacterCount(remaining);

      // Handle length exceeds maxLength
      if (_effectiveController.value.text.runes.length > widget.maxLength) {
        return effectiveDecoration.copyWith(
          errorText: effectiveDecoration.errorText ?? '',
          counterStyle: effectiveDecoration.errorStyle ??
              themeData.textTheme.caption.copyWith(color: themeData.errorColor),
          counterText: counterText,
          semanticCounterText: semanticCounterText,
        );
      }
    }

    return effectiveDecoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _controller = TextEditingController();
  }

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  void _handleTapDown(TapDownDetails details) {
    _renderEditable.handleTapDown(details);

    final PointerDeviceKind kind = details.kind;
    _shouldShowSelectionToolbar = kind == null ||
        kind == PointerDeviceKind.touch ||
        kind == PointerDeviceKind.stylus;
  }

  void _handleSingleTapUp(TapUpDetails details) {
    if (widget.selectionEnabled) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.iOS:
          _renderEditable.selectWordEdge(cause: SelectionChangedCause.tap);
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          _renderEditable.selectPosition(cause: SelectionChangedCause.tap);
          break;
      }
    }
    _requestKeyboard();
    if (widget.onTap != null) widget.onTap();
  }

  void _handleSingleLongTapStart(LongPressStartDetails details) {
    if (widget.selectionEnabled) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.iOS:
          _renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          _renderEditable.selectWord(cause: SelectionChangedCause.longPress);
          Feedback.forLongPress(context);
          break;
      }
    }
  }

  void _handleSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (widget.selectionEnabled) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.iOS:
          _renderEditable.selectPositionAt(
            from: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          _renderEditable.selectWordsInRange(
            from: details.globalPosition - details.offsetFromOrigin,
            to: details.globalPosition,
            cause: SelectionChangedCause.longPress,
          );
          break;
      }
    }
  }

  void _handleSingleLongTapEnd(LongPressEndDetails details) {
    if (widget.selectionEnabled) {
      if (_shouldShowSelectionToolbar)
        _editableTextKey.currentState.showToolbar();
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (widget.selectionEnabled) {
      _renderEditable.selectWord(cause: SelectionChangedCause.doubleTap);
      if (_shouldShowSelectionToolbar) {
        _editableText.showToolbar();
      }
    }
  }

  void _handleMouseDragSelectionStart(DragStartDetails details) {
    _renderEditable.selectPositionAt(
      from: details.globalPosition,
      cause: SelectionChangedCause.drag,
    );
  }

  void _handleMouseDragSelectionUpdate(
    DragStartDetails startDetails,
    DragUpdateDetails updateDetails,
  ) {
    _renderEditable.selectPositionAt(
      from: startDetails.globalPosition,
      to: updateDetails.globalPosition,
      cause: SelectionChangedCause.drag,
    );
  }

  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  void _handlePointerEnter(PointerEnterEvent event) => _handleHover(true);
  void _handlePointerExit(PointerExitEvent event) => _handleHover(false);

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        return _isHovering = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;

    return Semantics(
      onTap: () {
        if (!_effectiveController.selection.isValid)
          _effectiveController.selection =
              TextSelection.collapsed(offset: _effectiveController.text.length);
        _requestKeyboard();
      },
      child: Listener(
        onPointerEnter: _handlePointerEnter,
        onPointerExit: _handlePointerExit,
        child: IgnorePointer(
          ignoring: false,
          child: TextSelectionGestureDetector(
            onTapDown: _handleTapDown,
            onSingleTapUp: _handleSingleTapUp,
            onSingleLongTapStart: _handleSingleLongTapStart,
            onSingleLongTapMoveUpdate: _handleSingleLongTapMoveUpdate,
            onSingleLongTapEnd: _handleSingleLongTapEnd,
            onDoubleTapDown: _handleDoubleTapDown,
            onDragSelectionStart: _handleMouseDragSelectionStart,
            onDragSelectionUpdate: _handleMouseDragSelectionUpdate,
            behavior: HitTestBehavior.translucent,
            child: AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[focusNode, controller]),
              builder: (BuildContext context, Widget child) {
                return InputDecorator(
                  decoration: _getEffectiveDecoration(),
                  baseStyle: widget.style,
                  textAlign: widget.textAlign,
                  textAlignVertical: widget.textAlignVertical,
                  isHovering: _isHovering,
                  isFocused: focusNode.hasFocus,
                  isEmpty: controller.value.text.isEmpty,
                  expands: widget.expands,
                  child: RepaintBoundary(
                    child: SpannableEditableText(
                      key: _editableTextKey,
                      controller: widget.controller,
                      spannableController: widget.spannableController,
                      focusNode: widget.focusNode ?? FocusNode(),
                      style: widget.style ?? themeData.textTheme.subhead,
                      backgroundCursorColor: CupertinoColors.inactiveGray,
                      cursorColor: themeData.cursorColor,
                      keyboardType: TextInputType.multiline,
                      showCursor: true,
                      showSelectionHandles: true,
                      onSelectionHandleTapped: _handleSelectionHandleTapped,
                      selectionColor: themeData.textSelectionColor,
                      selectionControls: customTextSelectionControls,
                      enableInteractiveSelection: true,
                      maxLines: null,
                      autofocus: widget.autofocus,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MaterialTextSelectionControls extends TextSelectionControls {
  /// Returns the size of the Material handle.
  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_kHandleSize, _kHandleSize);

  /// Builder for material-style copy/paste text selection toolbar.
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
  ) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));

    // The toolbar should appear below the TextField
    // when there is not enough space above the TextField to show it.
    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final TextSelectionPoint endTextSelectionPoint =
        (endpoints.length > 1) ? endpoints[1] : null;
    final double x = (endTextSelectionPoint == null)
        ? startTextSelectionPoint.point.dx
        : (startTextSelectionPoint.point.dx + endTextSelectionPoint.point.dx) /
            2.0;
//    final double availableHeight = globalEditableRegion.top -
//        MediaQuery.of(context).padding.top -
//        _kToolbarScreenPadding;

    // Solve ignore text selection toolbar position
    final double y = startTextSelectionPoint.point.dy -
        _kToolbarHeight +
        _kToolbarScreenPadding * 2;

//    final double y = (availableHeight < _kToolbarHeight)
//        ? startTextSelectionPoint.point.dy +
//            globalEditableRegion.height +
//            _kToolbarHeight +
//            _kToolbarScreenPadding
//        : startTextSelectionPoint.point.dy - globalEditableRegion.height;

    final Offset preciseMidpoint = Offset(x, y);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(globalEditableRegion.size),
      child: CustomSingleChildLayout(
        delegate: _TextSelectionToolbarLayout(
          MediaQuery.of(context).size,
          globalEditableRegion,
          preciseMidpoint,
        ),
        child: _TextSelectionToolbar(
          handleCut: canCut(delegate) ? () => handleCut(delegate) : null,
          handleCopy: canCopy(delegate) ? () => handleCopy(delegate) : null,
          handlePaste: canPaste(delegate) ? () => handlePaste(delegate) : null,
          handleSelectAll:
              canSelectAll(delegate) ? () => handleSelectAll(delegate) : null,
        ),
      ),
    );
  }

  /// Builder for material-style text selection handles.
  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textHeight) {
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: CustomPaint(
        painter: _TextSelectionHandlePainter(
            color: Theme.of(context).textSelectionHandleColor),
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(
          angle: math.pi / 2.0,
          child: handle,
        );
      case TextSelectionHandleType.right: // points up-left
        return handle;
      case TextSelectionHandleType.collapsed: // points up
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
    }
    assert(type != null);
    return null;
  }

  /// Gets anchor for material-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kHandleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      default:
        return const Offset(_kHandleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Android allows SelectAll when selection is not collapsed, unless
    // everything has already been selected.
    final TextEditingValue value = delegate.textEditingValue;
    return value.text.isNotEmpty &&
        !(value.selection.start == 0 &&
            value.selection.end == value.text.length);
  }
}

class _TextSelectionHandlePainter extends CustomPainter {
  _TextSelectionHandlePainter({this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2.0;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, radius, radius), paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) {
    return color != oldPainter.color;
  }
}

class _TextSelectionToolbar extends StatelessWidget {
  const _TextSelectionToolbar({
    Key key,
    this.handleCut,
    this.handleCopy,
    this.handlePaste,
    this.handleSelectAll,
  }) : super(key: key);

  final VoidCallback handleCut;
  final VoidCallback handleCopy;
  final VoidCallback handlePaste;
  final VoidCallback handleSelectAll;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = <Widget>[];
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    if (handleCut != null)
      items.add(FlatButton(
          child: Text(localizations.cutButtonLabel), onPressed: handleCut));
    if (handleCopy != null)
      items.add(FlatButton(
          child: Text(localizations.copyButtonLabel), onPressed: handleCopy));
    if (handlePaste != null)
      items.add(FlatButton(
        child: Text(localizations.pasteButtonLabel),
        onPressed: handlePaste,
      ));
    if (handleSelectAll != null)
      items.add(FlatButton(
          child: Text(localizations.selectAllButtonLabel),
          onPressed: handleSelectAll));

    // If there is no option available, build an empty widget.
    if (items.isEmpty) {
      return Container(width: 0.0, height: 0.0);
    }

    return Material(
      elevation: 1.0,
      child: Container(
        height: _kToolbarHeight,
        child: Row(mainAxisSize: MainAxisSize.min, children: items),
      ),
    );
  }
}

class _TextSelectionToolbarLayout extends SingleChildLayoutDelegate {
  _TextSelectionToolbarLayout(
      this.screenSize, this.globalEditableRegion, this.position);

  /// The size of the screen at the time that the toolbar was last laid out.
  final Size screenSize;

  /// Size and position of the editing region at the time the toolbar was last
  /// laid out, in global coordinates.
  final Rect globalEditableRegion;

  /// Anchor position of the toolbar, relative to the top left of the
  /// [globalEditableRegion].
  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final Offset globalPosition = globalEditableRegion.topLeft + position;

    double x = globalPosition.dx - childSize.width / 2.0;
    double y = globalPosition.dy - childSize.height;

    if (x < _kToolbarScreenPadding)
      x = _kToolbarScreenPadding;
    else if (x + childSize.width > screenSize.width - _kToolbarScreenPadding)
      x = screenSize.width - childSize.width - _kToolbarScreenPadding;

    if (y < _kToolbarScreenPadding)
      y = _kToolbarScreenPadding;
    else if (y + childSize.height > screenSize.height - _kToolbarScreenPadding)
      y = screenSize.height - childSize.height - _kToolbarScreenPadding;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TextSelectionToolbarLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
