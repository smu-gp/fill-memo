import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

abstract class HistoryListState extends Equatable {
  HistoryListState([List props = const []]) : super(props);
}

class UnSelectableList extends HistoryListState {
  @override
  String toString() => 'UnSelectableList';
}

class SelectableList extends HistoryListState {
  final int selectedItemCount;
  final List<History> selectedItems;

  SelectableList({
    @required this.selectedItemCount,
    @required this.selectedItems,
  }) : super([selectedItemCount, selectedItems]);

  @override
  String toString() =>
      'SelectableList{selectedItemCount: $selectedItemCount, selectedItems: $selectedItems}';
}
