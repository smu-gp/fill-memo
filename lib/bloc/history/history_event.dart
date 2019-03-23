import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class HistoryEvent extends Equatable {
  HistoryEvent([List props = const []]) : super(props);
}

class LoadHistory extends HistoryEvent {
  final SortOrder order;

  LoadHistory(this.order) : super([order]);

  @override
  String toString() => 'LoadHistory{order: $order}';
}

class UpdateHistory extends HistoryEvent {
  final History updatedHistory;

  UpdateHistory(this.updatedHistory) : super([updatedHistory]);

  @override
  String toString() => 'UpdateHistory{updatedHistory: $updatedHistory}';
}

class DeleteHistory extends HistoryEvent {
  final int id;

  DeleteHistory(this.id) : super([id]);

  @override
  String toString() => 'DeleteHistory{id: $id}';
}
