import 'package:bloc/bloc.dart';

import './list_event.dart';
import './list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  @override
  ListState get initialState => UnSelectableList();

  @override
  Stream<ListState> mapEventToState(
    ListEvent event,
  ) async* {
    if (event is UnSelectable) {
      yield* _mapUnSelectableToState();
    } else if (event is Selectable) {
      yield* _mapSelectableToState();
    } else if (event is SelectItem) {
      yield* _mapSelectItemToState(event);
    } else if (event is UnSelectItem) {
      yield* _mapUnSelectItemToState(event);
    }
  }

  Stream<ListState> _mapUnSelectableToState() async* {
    yield UnSelectableList();
  }

  Stream<ListState> _mapSelectableToState() async* {
    yield SelectableList(
      selectedItemCount: 0,
      selectedItems: [],
    );
  }

  Stream<ListState> _mapSelectItemToState(SelectItem event) async* {
    var items = (currentState is SelectableList
        ? (currentState as SelectableList).selectedItems
        : <dynamic>[])
      ..add(event.selectedItem);
    yield SelectableList(
      selectedItemCount: items.length,
      selectedItems: items,
    );
  }

  Stream<ListState> _mapUnSelectItemToState(UnSelectItem event) async* {
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
