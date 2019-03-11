import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

class HistoryListBloc extends Bloc<HistoryListEvent, HistoryListState> {
  @override
  HistoryListState get initialState => UnselectableList();

  @override
  Stream<HistoryListState> mapEventToState(
    HistoryListState currentState,
    HistoryListEvent event,
  ) async* {
    if (event is UnselectableEvent) {
      yield UnselectableList();
    } else if (event is SelectableEvent) {
      yield SelectableList(
        selectedItemCount: 0,
        selectedItems: [],
      );
    } else if (event is SelectItemEvent) {
      var items = (currentState is SelectableList
          ? currentState.selectedItems
          : <History>[])
        ..add(event.selectedItem);
      yield SelectableList(
        selectedItemCount: items.length,
        selectedItems: items,
      );
    } else if (event is UnSelectItemEvent) {
      var state = currentState as SelectableList;
      var items = state.selectedItems
          .where((item) => item != event.unselectedItem)
          .toList();
      yield (items.length > 0
          ? SelectableList(
              selectedItemCount: items.length,
              selectedItems: items,
            )
          : UnselectableList());
    }
  }
}

abstract class HistoryListEvent extends Equatable {
  HistoryListEvent([List props = const []]) : super(props);
}

class UnselectableEvent extends HistoryListEvent {}

class SelectableEvent extends HistoryListEvent {}

class SelectItemEvent extends HistoryListEvent {
  final History selectedItem;

  SelectItemEvent({@required this.selectedItem})
      : assert(selectedItem != null),
        super([selectedItem]);

  @override
  String toString() {
    return 'SelectItemEvent{selectedItem: $selectedItem}';
  }
}

class UnSelectItemEvent extends HistoryListEvent {
  final History unselectedItem;

  UnSelectItemEvent({@required this.unselectedItem})
      : assert(unselectedItem != null),
        super([unselectedItem]);

  @override
  String toString() {
    return 'UnSelectItemEvent{unselectedItem: $unselectedItem}';
  }
}

abstract class HistoryListState extends Equatable {
  HistoryListState([List props = const []]) : super(props);
}

class UnselectableList extends HistoryListState {}

class SelectableList extends HistoryListState {
  final int selectedItemCount;
  final List<History> selectedItems;

  SelectableList(
      {@required this.selectedItemCount, @required this.selectedItems})
      : assert(selectedItemCount != null),
        assert(selectedItems != null),
        super([selectedItemCount, selectedItems]);

  @override
  String toString() {
    return 'SelectableList{selectedItemCount: $selectedItemCount, selectedItems: $selectedItems}';
  }
}
