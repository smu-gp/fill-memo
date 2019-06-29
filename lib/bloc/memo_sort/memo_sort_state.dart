import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class _MemoSortState extends Equatable {
  _MemoSortState([List props = const []]) : super(props);
}

class MemoSortState extends _MemoSortState {
  final SortOrderBy orderBy;
  final SortOrderType sortType;

  MemoSortState(this.orderBy, this.sortType) : super([orderBy, sortType]);

  @override
  String toString() {
    return 'MemoSortState{orderBy: $orderBy, sortType: $sortType}';
  }
}
