import 'package:equatable/equatable.dart';

abstract class ListEvent extends Equatable {
  ListEvent([List props = const []]) : super(props);
}

class UnSelectable extends ListEvent {
  @override
  String toString() => 'UnSelectable';
}

class Selectable extends ListEvent {
  @override
  String toString() => 'Selectable';
}

class SelectItem extends ListEvent {
  final dynamic selectedItem;

  SelectItem(this.selectedItem) : super([selectedItem]);

  @override
  String toString() => 'SelectItem{selectedItem: $selectedItem}';
}

class UnSelectItem extends ListEvent {
  final dynamic unselectedItem;

  UnSelectItem(this.unselectedItem) : super([unselectedItem]);

  @override
  String toString() => 'UnSelectItem{unselectedItem: $unselectedItem}';
}
