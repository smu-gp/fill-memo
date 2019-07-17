import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sp_client/widget/rich_text_editor/service/spannable_text.dart';
import 'package:sp_client/widget/rich_text_editor/util/spannable_style.dart';

class StyleToolbar extends StatefulWidget {
  final SpannableTextController controller;

  StyleToolbar({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _StyleToolbarState createState() => _StyleToolbarState();
}

class _StyleToolbarState extends State<StyleToolbar> {
  final StreamController<SpannableTextValue> _streamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      _streamController.sink.add(widget.controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SpannableTextValue>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        var currentStyle;
        var currentSelection;
        if (snapshot.hasData) {
          var value = snapshot.data;
          var selection = value.selection;
          if (selection != null && !selection.isCollapsed) {
            currentSelection = selection;
            currentStyle = widget.controller.getSelectionStyle(selection);
          } else {
            currentStyle = value.composingStyle;
          }
        }
        return Row(
          children: _buildActions(
            currentStyle ?? SpannableStyle(),
            currentSelection,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  List<Widget> _buildActions(
      SpannableStyle spannableStyle, TextSelection selection) {
    final Map<int, IconData> styleMap = {
      styleBold: Icons.format_bold,
      styleItalic: Icons.format_italic,
      styleUnderline: Icons.format_underlined,
      styleLineThrough: Icons.format_strikethrough,
    };

    return styleMap.keys
        .map((style) => IconButton(
              icon: Icon(
                styleMap[style],
                color: spannableStyle.hasStyle(style)
                    ? Theme.of(context).accentColor
                    : null,
              ),
              onPressed: () => _toggleTextStyle(
                spannableStyle.copy(),
                style,
                selection: selection,
              ),
            ))
        .toList();
  }

  void _toggleTextStyle(
    SpannableStyle spannableStyle,
    int textStyle, {
    TextSelection selection,
  }) {
    bool hasSelection = selection != null;
    if (spannableStyle.hasStyle(textStyle)) {
      if (hasSelection) {
        widget.controller.updateSelectionStyle(
            selection, (style) => style..clearStyle(textStyle));
      } else {
        widget.controller.composingStyle = spannableStyle
          ..clearStyle(textStyle);
      }
    } else {
      if (hasSelection) {
        widget.controller.updateSelectionStyle(
            selection, (style) => style..setStyle(textStyle));
      } else {
        widget.controller.composingStyle = spannableStyle..setStyle(textStyle);
      }
    }
  }
}
