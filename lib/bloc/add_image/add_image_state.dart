import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AddImageState extends Equatable {
  AddImageState([List props = const []]) : super(props);
}

class ReadyImage extends AddImageState {
  final String imagePath;
  final Rect clipRect;

  ReadyImage(this.imagePath, {this.clipRect}) : super([imagePath, clipRect]);

  @override
  String toString() => 'ReadyImage';
}

class CropImage extends AddImageState {
  final String imagePath;

  CropImage(this.imagePath) : super([imagePath]);

  @override
  String toString() => 'CropImage';
}
