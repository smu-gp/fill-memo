import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AddImageEvent extends Equatable {
  AddImageEvent([List props = const []]) : super(props);
}

class SendImage extends AddImageEvent {
  @override
  String toString() => 'SendImage';
}

class StartCrop extends AddImageEvent {
  @override
  String toString() => 'StartCrop';
}

class SaveCrop extends AddImageEvent {
  final Rect cropRect;

  SaveCrop(this.cropRect) : super([cropRect]);

  @override
  String toString() => 'SaveCrop';
}

class UndoCrop extends AddImageEvent {
  @override
  String toString() => 'UndoCrop';
}
