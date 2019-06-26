import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class MemoSortEvent extends Equatable {
  MemoSortEvent([List props = const []]) : super(props);
}

class ChangeSort extends MemoSortEvent {
  final SortOrder order;

  ChangeSort(this.order) : super([order]);

  @override
  String toString() {
    return 'ChangeSort{order: $order}';
  }
}
