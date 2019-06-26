import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/models.dart';

@immutable
abstract class MemoState extends Equatable {
  MemoState([List props = const []]) : super(props);
}

class MemoLoading extends MemoState {
  @override
  String toString() {
    return 'MemoLoading{}';
  }
}

class MemoLoaded extends MemoState {
  final List<Memo> memoList;

  MemoLoaded(this.memoList) : super([memoList]);

  @override
  String toString() {
    return 'MemoLoaded{memoList: $memoList}';
  }
}

class MemoNotLoaded extends MemoState {
  final Exception exception;

  MemoNotLoaded(this.exception) : super([exception]);

  @override
  String toString() {
    return 'MemoNotLoaded{exception: $exception}';
  }
}
