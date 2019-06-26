import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class _MemoSortState extends Equatable {
  _MemoSortState([List props = const []]) : super(props);
}

class MemoSortState extends _MemoSortState {
  final SortOrder order;

  MemoSortState(this.order) : super([order]);

  @override
  String toString() {
    return 'MemoSortState{order: $order}';
  }
}
