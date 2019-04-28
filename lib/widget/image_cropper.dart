import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum _HandleType { topLeft, topRight, bottomLeft, bottomRight, none }

const double _kHandleRange = 20.0;
const double _kDefaultMinimumSize = 50.0;

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

  double _left = 0;
  double _top = 0;
  double _right = 0;
  double _bottom = 0;
  double _widgetWidth = 0;
  double _widgetHeight = 0;

  _HandleType _currentHandleType = _HandleType.none;

  @override
  void initState() {
    super.initState();
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
        child: Image(
          image: widget.image,
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
    _imageStream?.removeListener(_initRect);
    super.dispose();
  }

  void _updateImage() {
    var oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    oldImageStream?.removeListener(_initRect);
    _imageStream.addListener(_initRect);
  }

  void _initRect(ImageInfo imageInfo, bool synchronousCall) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        var size = context.size;
        _right = size.width;
        _bottom = size.height;
        _widgetWidth = size.width;
        _widgetHeight = size.height;
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
          if (updatedOffset.dx - (guideWidth / 2) >= 0 &&
              updatedOffset.dx + (guideWidth / 2) <= _widgetWidth) {
            _left = updatedOffset.dx - (guideWidth / 2);
            _right = updatedOffset.dx + (guideWidth / 2);
          }
          if (updatedOffset.dy - (guideHeight / 2) >= 0 &&
              updatedOffset.dy + (guideHeight / 2) <= _widgetHeight) {
            _top = updatedOffset.dy - (guideHeight / 2);
            _bottom = updatedOffset.dy + (guideHeight / 2);
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
      _isInRange(0, offset.dx, _widgetWidth) &&
      _isInRange(0, offset.dy, _widgetHeight);

  bool _isInRange(dynamic start, dynamic target, dynamic end) =>
      start <= target && target <= end;

  Future<ImageInfo> _getImageInfo(ImageProvider imageProvider) {
    Completer<ImageInfo> completer = Completer<ImageInfo>();
    imageProvider
        .resolve(createLocalImageConfiguration(context))
        .addListener((ImageInfo info, _) => completer.complete(info));
    return completer.future;
  }

  Future<Rect> getActualCropRect() async {
    var imageInfo = await _getImageInfo(widget.image);
    var widthRatio = imageInfo.image.width / widgetRect.width;
    var heightRatio = imageInfo.image.height / widgetRect.height;
    var actualLeft = guideRect.left * widthRatio;
    var actualTop = guideRect.top * heightRatio;
    var actualWidth = guideRect.width * widthRatio;
    var actualHeight = guideRect.height * heightRatio;
    return Rect.fromLTWH(actualLeft, actualTop, actualWidth, actualHeight);
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
      Rect.fromLTWH(0, guideRect.top, guideRect.left, size.height),
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
    canvas.drawCircle(guideRect.topLeft, 5.0, handlePaint);
    canvas.drawCircle(guideRect.topRight, 5.0, handlePaint);
    canvas.drawCircle(guideRect.bottomLeft, 5.0, handlePaint);
    canvas.drawCircle(guideRect.bottomRight, 5.0, handlePaint);

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
