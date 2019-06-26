import 'package:bloc/bloc.dart';
import 'package:sp_client/model/models.dart';

import './memo_list_event.dart';
import './memo_list_state.dart';

class MemoListBloc extends Bloc<MemoListEvent, MemoListState> {
  @override
  MemoListState get initialState => UnSelectableList();

  @override
  Stream<MemoListState> mapEventToState(
    MemoListEvent event,
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

  Stream<MemoListState> _mapUnSelectableToState() async* {
    yield UnSelectableList();
  }

  Stream<MemoListState> _mapSelectableToState() async* {
    yield SelectableList(
      selectedItemCount: 0,
      selectedItems: [],
    );
  }

  Stream<MemoListState> _mapSelectItemToState(SelectItem event) async* {
    var items = (currentState is SelectableList
        ? (currentState as SelectableList).selectedItems
        : <Memo>[])
      ..add(event.selectedItem);
    yield SelectableList(
      selectedItemCount: items.length,
      selectedItems: items,
    );
  }

  Stream<MemoListState> _mapUnSelectItemToState(UnSelectItem event) async* {
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
