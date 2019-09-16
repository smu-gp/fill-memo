import 'dart:math';

import 'package:fill_memo/widget/painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class CustomPanGestureRecognizer extends PanGestureRecognizer {
  final Function onPanStart;
  final Function onPanUpdate;
  final Function onPanEnd;
  final BuildContext context;
  final PainterController controller;
  Offset _before;
  CustomPanGestureRecognizer({
    @required this.onPanStart,
    @required this.onPanUpdate,
    @required this.onPanEnd,
    @required this.context,
    @required this.controller,
  });

  static bool isLarge(BuildContext context) {
    assert(context != null);
    var size = MediaQuery.of(context).size;
    return min(size.width, size.height) > 600;
  }

  @override
  void addPointer(PointerEvent event) {
    int p = 0;
    if (isLarge(context)) {
      if (!controller.penOrfinger) {
        if (event.kind == PointerDeviceKind.stylus) {
          startTrackingPointer(event.pointer);
          resolve(GestureDisposition.accepted);
        } else {
          stopTrackingPointer(event.pointer);
        }
      } else {
        if (event.kind == PointerDeviceKind.touch) {
          startTrackingPointer(event.pointer);
          resolve(GestureDisposition.accepted);
        } else {
          stopTrackingPointer(event.pointer);
        }
      }
    } else {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      onPanStart(new DragStartDetails(globalPosition: event.position));
    } else if (event is PointerMoveEvent) {
      onPanUpdate(new DragUpdateDetails(globalPosition: event.position));
    } else if (event is PointerUpEvent) {
      onPanEnd(new DragEndDetails());
    }
  }

  @override
  String get debugDescription => 'customPan';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
