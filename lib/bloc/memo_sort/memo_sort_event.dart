import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class MemoSortEvent extends Equatable {
  MemoSortEvent([List props = const []]) : super(props);
}

class ChangeSort extends MemoSortEvent {
  final SortOrderBy orderBy;
  final SortOrderType sortType;

  ChangeSort({this.orderBy, this.sortType}) : super([orderBy, sortType]);

  @override
  String toString() {
    return 'ChangeSort{orderBy: $orderBy, sortType: $sortType}';
  }
}
