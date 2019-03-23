import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

abstract class HistoryState extends Equatable {
  HistoryState([List props = const []]) : super(props);
}

class HistoryLoading extends HistoryState {
  @override
  String toString() => 'HistoryLoading';
}

class HistoryLoaded extends HistoryState {
  final List<History> histories;
  final SortOrder order;

  HistoryLoaded({
    @required this.histories,
    @required this.order,
  }) : super([histories, order]);

  @override
  String toString() => 'HistoryLoaded{histories: $histories, order: $order}';
}

class HistoryNotLoaded extends HistoryState {
  @override
  String toString() => 'HistoryNotLoaded';
}
