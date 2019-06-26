import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class MemoListEvent extends Equatable {
  MemoListEvent([List props = const []]) : super(props);
}

class UnSelectable extends MemoListEvent {
  @override
  String toString() => 'UnSelectable';
}

class Selectable extends MemoListEvent {
  @override
  String toString() => 'Selectable';
}

class SelectItem extends MemoListEvent {
  final Memo selectedItem;

  SelectItem(this.selectedItem) : super([selectedItem]);

  @override
  String toString() => 'SelectItem{selectedItem: $selectedItem}';
}

class UnSelectItem extends MemoListEvent {
  final Memo unselectedItem;

  UnSelectItem(this.unselectedItem) : super([unselectedItem]);

  @override
  String toString() => 'UnSelectItem{unselectedItem: $unselectedItem}';
}
