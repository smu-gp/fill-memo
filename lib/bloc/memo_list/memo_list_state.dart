import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class MemoListState extends Equatable {
  MemoListState([List props = const []]) : super(props);
}

class UnSelectableList extends MemoListState {
  @override
  String toString() => 'UnSelectableList';
}

class SelectableList extends MemoListState {
  final int selectedItemCount;
  final List<Memo> selectedItems;

  SelectableList({
    @required this.selectedItemCount,
    @required this.selectedItems,
  }) : super([selectedItemCount, selectedItems]);

  @override
  String toString() =>
      'SelectableList{selectedItemCount: $selectedItemCount, selectedItems: $selectedItems}';
}
