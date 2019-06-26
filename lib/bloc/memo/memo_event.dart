import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MemoEvent extends Equatable {
  MemoEvent([List props = const []]) : super(props);
}

class ReadMemo extends MemoEvent {
  @override
  String toString() {
    return 'ReadMemo{}';
  }
}
