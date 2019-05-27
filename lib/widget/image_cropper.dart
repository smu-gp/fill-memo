import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum _HandleType { topLeft, topRight, bottomLeft, bottomRight, none }

const double _kHandleOffset = 4.0;
const double _kHandleSize = 6.0;
const double _kHandleRange = 24.0;
const double _kDefaultMinimumSize = 48.0;

class ImageCropper extends StatefulWidget {
  final ImageProvider image;
  final double minWidth;
  final double minHeight;
  final bool overlayHandleRange;

  const ImageCropper({
    Key key,
    @required this.image,
    this.minWidth = _kDefaultMinimumSize,
    this.minHeight = _kDefaultMinimumSize,
    this.overlayHandleRange,
  }) : super(key: key);

  @override
  ImageCropperState createState() => ImageCropperState();
}

class ImageCropperState extends State<ImageCropper> {
  ImageStream _imageStream;
  ImageStreamListener _imageStreamListener;

  double _left = _kHandleOffset;
  double _top = _kHandleOffset;
  double _right = 0;
  double _bottom = 0;
  double _widgetWidth = 0;
  double _widgetHeight = 0;

  _HandleType _currentHandleType = _HandleType.none;

  @override
  void initState() {
    super.initState();
    _imageStreamListener = ImageStreamListener(_initRect);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      child: CustomPaint(
        foregroundPainter: _CropGuide(
          guideRect: guideRect,
          overlayHandleRange: widget.overlayHandleRange,
        ),
        child: Padding(
          padding: EdgeInsets.all(_kHandleOffset),
          child: Image(
            image: widget.image,
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateImage();
  }

  @override
  void didUpdateWidget(ImageCropper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _updateImage();
    }
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageStreamListener);
    super.dispose();
  }

  void _updateImage() {
    var oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    oldImageStream?.removeListener(_imageStreamListener);
    _imageStream.addListener(_imageStreamListener);
  }

  void _initRect(ImageInfo imageInfo, bool synchronousCall) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        var size = context.size;
        _right = size.width - _kHandleOffset;
        _bottom = size.height - _kHandleOffset;
        _widgetWidth = size.width - (_kHandleOffset * 2);
        _widgetHeight = size.height - (_kHandleOffset * 2);
      });
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  Rect get guideRect => Rect.fromLTRB(_left, _top, _right, _bottom);

  Rect get widgetRect => Offset.zero & Size(_widgetWidth, _widgetHeight);

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _currentHandleType = _getHandleType(_getLocalOffset(details.focalPoint));
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    var updatedOffset = _getLocalOffset(details.focalPoint);
    if (!_isOffsetInWidget(updatedOffset)) return;
    setState(() {
      switch (_currentHandleType) {
        case _HandleType.topLeft:
          if (_right - updatedOffset.dx >= widget.minWidth) {
            _left = updatedOffset.dx;
          }
          if (_bottom - updatedOffset.dy >= widget.minHeight) {
            _top = updatedOffset.dy;
          }
          break;
        case _HandleType.topRight:
          if (_bottom - updatedOffset.dy >= widget.minHeight) {
            _top = updatedOffset.dy;
          }
          if (updatedOffset.dx - _left >= widget.minWidth) {
            _right = updatedOffset.dx;
          }
          break;
        case _HandleType.bottomLeft:
          if (_right - updatedOffset.dx >= widget.minWidth) {
            _left = updatedOffset.dx;
          }
          if (updatedOffset.dy - _top >= widget.minHeight) {
            _bottom = updatedOffset.dy;
          }
          break;
        case _HandleType.bottomRight:
          if (updatedOffset.dy - _top >= widget.minHeight) {
            _bottom = updatedOffset.dy;
          }
          if (updatedOffset.dx - _left >= widget.minWidth) {
            _right = updatedOffset.dx;
          }
          break;
        case _HandleType.none:
          var guideWidth = _right - _left;
          var guideHeight = _bottom - _top;

          var newLeft = updatedOffset.dx - (guideWidth / 2);
          var newRight = updatedOffset.dx + (guideWidth / 2);
          if (newLeft >= _kHandleOffset &&
              newRight <= _widgetWidth + _kHandleOffset) {
            _left = newLeft;
            _right = newRight;
          }
          var newTop = updatedOffset.dy - (guideHeight / 2);
          var newBottom = updatedOffset.dy + (guideHeight / 2);
          if (newTop >= _kHandleOffset &&
              newBottom <= _widgetHeight + _kHandleOffset) {
            _top = newTop;
            _bottom = newBottom;
          }
          break;
      }
    });
  }

  Offset _getLocalOffset(Offset offset) {
    RenderBox box = context.findRenderObject();
    return box.globalToLocal(offset);
  }

  _HandleType _getHandleType(Offset offset) {
    var minLeft = _left - _kHandleRange;
    var minTop = _top - _kHandleRange;
    if (_isInRange(minLeft, offset.dx, _left + _kHandleRange) &&
        _isInRange(minTop, offset.dy, _top + _kHandleRange)) {
      return _HandleType.topLeft;
    } else if (_isInRange(
            _right - _kHandleRange, offset.dx, _right + _kHandleRange) &&
        _isInRange(minTop, offset.dy, _top + _kHandleRange)) {
      return _HandleType.topRight;
    } else if (_isInRange(minLeft, offset.dx, _left + _kHandleRange) &&
        _isInRange(
            _bottom - _kHandleRange, offset.dy, _bottom + _kHandleRange)) {
      return _HandleType.bottomLeft;
    } else if (_isInRange(
            _right - _kHandleRange, offset.dx, _right + _kHandleRange) &&
        _isInRange(
            _bottom - _kHandleRange, offset.dy, _bottom + _kHandleRange)) {
      return _HandleType.bottomRight;
    }
    return _HandleType.none;
  }

  bool _isOffsetInWidget(Offset offset) =>
      _isInRange(_kHandleOffset, offset.dx, _widgetWidth + _kHandleOffset) &&
      _isInRange(_kHandleOffset, offset.dy, _widgetHeight + _kHandleOffset);

  bool _isInRange(dynamic start, dynamic target, dynamic end) =>
      start <= target && target <= end;

  Future<ImageInfo> _getImageInfo(ImageProvider imageProvider) {
    Completer<ImageInfo> completer = Completer<ImageInfo>();
    imageProvider.resolve(createLocalImageConfiguration(context)).addListener(
          ImageStreamListener(
            (ImageInfo info, bool synchronousCall) => completer.complete(info),
          ),
        );
    return completer.future;
  }

  Rect getWidgetCropRect() {
    return guideRect;
  }

  Future<Rect> getActualCropRect() async {
    var imageInfo = await _getImageInfo(widget.image);
    var widthRatio = imageInfo.image.width / widgetRect.width;
    var heightRatio = imageInfo.image.height / widgetRect.height;
    var actualLeft = (guideRect.left - _kHandleOffset) * widthRatio;
    var actualTop = (guideRect.top - _kHandleOffset) * heightRatio;
    var actualWidth = guideRect.width * widthRatio;
    var actualHeight = guideRect.height * heightRatio;
    return Rect.fromLTWH(
      actualLeft.roundToDouble(),
      actualTop.roundToDouble(),
      actualWidth.roundToDouble(),
      actualHeight.roundToDouble(),
    );
  }
}

class _CropGuide extends CustomPainter {
  Rect guideRect;
  bool overlayHandleRange;

  _CropGuide({
    @required this.guideRect,
    this.overlayHandleRange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw guide
    var guidePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 1;
    canvas.drawRect(guideRect, guidePaint);
    var guideOutsidePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black45;
    // Draw outside top
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, guideRect.top),
      guideOutsidePaint,
    );
    // Draw outside left
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        guideRect.top,
        guideRect.left,
        size.height - guideRect.top,
      ),
      guideOutsidePaint,
    );
    // Draw outside bottom
    canvas.drawRect(
      Rect.fromLTWH(
        guideRect.left,
        guideRect.bottom,
        size.width - guideRect.left,
        size.height - guideRect.bottom,
      ),
      guideOutsidePaint,
    );
    // Draw outside right
    canvas.drawRect(
      Rect.fromLTWH(
        guideRect.right,
        guideRect.top,
        size.width - guideRect.right,
        guideRect.height,
      ),
      guideOutsidePaint,
    );
    // Draw handle
    var handlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;
    canvas.drawCircle(guideRect.topLeft, _kHandleSize, handlePaint);
    canvas.drawCircle(guideRect.topRight, _kHandleSize, handlePaint);
    canvas.drawCircle(guideRect.bottomLeft, _kHandleSize, handlePaint);
    canvas.drawCircle(guideRect.bottomRight, _kHandleSize, handlePaint);

    // Draw overlay handle range
    if (overlayHandleRange) {
      var overlayHandleRangePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Color(0x56E57373);

      canvas.drawRect(
          Rect.fromLTWH(
            guideRect.left - _kHandleRange,
            guideRect.top - _kHandleRange,
            _kHandleRange * 2,
            _kHandleRange * 2,
          ),
          overlayHandleRangePaint);

      canvas.drawRect(
          Rect.fromLTWH(
            guideRect.right - _kHandleRange,
            guideRect.top - _kHandleRange,
            _kHandleRange * 2,
            _kHandleRange * 2,
          ),
          overlayHandleRangePaint);

      canvas.drawRect(
          Rect.fromLTWH(
            guideRect.left - _kHandleRange,
            guideRect.bottom - _kHandleRange,
            _kHandleRange * 2,
            _kHandleRange * 2,
          ),
          overlayHandleRangePaint);

      canvas.drawRect(
          Rect.fromLTWH(
            guideRect.right - _kHandleRange,
            guideRect.bottom - _kHandleRange,
            _kHandleRange * 2,
            _kHandleRange * 2,
          ),
          overlayHandleRangePaint);
    }
  }

  @override
  bool shouldRepaint(_CropGuide oldDelegate) {
    return oldDelegate.guideRect != guideRect;
  }
}
