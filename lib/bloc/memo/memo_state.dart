import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class MemoState extends Equatable {
  MemoState([List props = const []]) : super(props);
}

class MemosLoading extends MemoState {
  @override
  String toString() => '$runtimeType';
}

class MemosLoaded extends MemoState {
  final List<Memo> memos;

  MemosLoaded([this.memos = const []]) : super([memos]);

  @override
  String toString() => '$runtimeType(memos: $memos)';
}

class MemosNotLoaded extends MemoState {
  final Object exception;

  MemosNotLoaded(this.exception) : super([exception]);

  @override
  String toString() => '$runtimeType(exception: $exception)';
}
