import 'package:equatable/equatable.dart';

abstract class FolderEvent extends Equatable {
  FolderEvent([List props = const []]) : super(props);
}

class ReadFolder extends FolderEvent {
  @override
  String toString() => "LoadFolder";
}
