import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ListState extends Equatable {
  ListState([List props = const []]) : super(props);
}

class UnSelectableList extends ListState {
  @override
  String toString() => 'UnSelectableList';
}

class SelectableList extends ListState {
  final int selectedItemCount;
  final List<dynamic> selectedItems;

  SelectableList({
    @required this.selectedItemCount,
    @required this.selectedItems,
  }) : super([selectedItemCount, selectedItems]);

  @override
  String toString() =>
      'SelectableList{selectedItemCount: $selectedItemCount, selectedItems: $selectedItems}';
}
