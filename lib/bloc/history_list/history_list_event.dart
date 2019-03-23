import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class HistoryListEvent extends Equatable {
  HistoryListEvent([List props = const []]) : super(props);
}

class UnSelectable extends HistoryListEvent {
  @override
  String toString() => 'UnSelectable';
}

class Selectable extends HistoryListEvent {
  @override
  String toString() => 'Selectable';
}

class SelectItem extends HistoryListEvent {
  final History selectedItem;

  SelectItem(this.selectedItem) : super([selectedItem]);

  @override
  String toString() => 'SelectItem{selectedItem: $selectedItem}';
}

class UnSelectItem extends HistoryListEvent {
  final History unselectedItem;

  UnSelectItem(this.unselectedItem) : super([unselectedItem]);

  @override
  String toString() => 'UnSelectItem{unselectedItem: $unselectedItem}';
}
