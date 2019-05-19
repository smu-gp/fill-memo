import 'package:bloc/bloc.dart';
import 'package:sp_client/bloc/history_list/history_list_event.dart';
import 'package:sp_client/bloc/history_list/history_list_state.dart';
import 'package:sp_client/model/models.dart';

class HistoryListBloc extends Bloc<HistoryListEvent, HistoryListState> {
  @override
  HistoryListState get initialState => UnSelectableList();

  @override
  Stream<HistoryListState> mapEventToState(
    HistoryListEvent event,
  ) async* {
    if (event is UnSelectable) {
      yield* _mapUnSelectableToState();
    } else if (event is Selectable) {
      yield* _mapSelectableToState();
    } else if (event is SelectItem) {
      yield* _mapSelectItemToState(currentState, event);
    } else if (event is UnSelectItem) {
      yield* _mapUnSelectItemToState(currentState, event);
    }
  }

  Stream<HistoryListState> _mapUnSelectableToState() async* {
    yield UnSelectableList();
  }

  Stream<HistoryListState> _mapSelectableToState() async* {
    yield SelectableList(
      selectedItemCount: 0,
      selectedItems: [],
    );
  }

  Stream<HistoryListState> _mapSelectItemToState(
    HistoryListState currentState,
    SelectItem event,
  ) async* {
    var items = (currentState is SelectableList
        ? currentState.selectedItems
        : <History>[])
      ..add(event.selectedItem);
    yield SelectableList(
      selectedItemCount: items.length,
      selectedItems: items,
    );
  }

  Stream<HistoryListState> _mapUnSelectItemToState(
    HistoryListState currentState,
    UnSelectItem event,
  ) async* {
    var state = currentState as SelectableList;
    var items = state.selectedItems
        .where((item) => item != event.unselectedItem)
        .toList();
    yield (items.length > 0
        ? SelectableList(
            selectedItemCount: items.length,
            selectedItems: items,
          )
        : UnSelectableList());
  }
}
