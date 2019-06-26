import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sp_client/model/models.dart';

import 'memo_sort_event.dart';
import 'memo_sort_state.dart';

class MemoSortBloc extends Bloc<MemoSortEvent, MemoSortState> {
  @override
  MemoSortState get initialState => MemoSortState(SortOrder.createdAtDes);

  @override
  Stream<MemoSortState> mapEventToState(
    MemoSortEvent event,
  ) async* {
    if (event is ChangeSort) {
      yield MemoSortState(event.order);
    }
  }
}
