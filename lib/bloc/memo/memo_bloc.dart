import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/widget/rich_text_field/rich_text_field.dart';

import 'memo_event.dart';
import 'memo_state.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  final MemoRepository _memoRepository;
  StreamSubscription _memoSubscription;

  MemoBloc({@required MemoRepository memoRepository})
      : assert(memoRepository != null),
        _memoRepository = memoRepository;

  @override
  MemoState get initialState => MemosLoading();

  @override
  Stream<MemoState> mapEventToState(
    MemoEvent event,
  ) async* {
    if (event is LoadMemos) {
      yield* _mapLoadMemosToState(event);
    } else if (event is AddMemo) {
      yield* _mapAddMemoToState(event);
    } else if (event is UpdateMemo) {
      yield* _mapUpdateMemoToState(event);
    } else if (event is DeleteMemo) {
      yield* _mapDeleteMemoToState(event);
    } else if (event is MergeMemo) {
      yield* _mapMergeMemoToState(event);
    } else if (event is MemosUpdated) {
      yield* _mapMemosUpdateToState(event);
    } else if (event is UpdateMemoUser) {
      yield* _mapUpdateMemoUserToState(event);
    }
  }

  Stream<MemoState> _mapLoadMemosToState(LoadMemos event) async* {
    _memoSubscription?.cancel();
    _memoSubscription = _memoRepository.memos().listen(
      (memos) {
        dispatch(
          MemosUpdated(memos),
        );
      },
    );
  }

  Stream<MemoState> _mapAddMemoToState(AddMemo event) async* {
    _memoRepository.addNewMemo(event.memo);
  }

  Stream<MemoState> _mapUpdateMemoToState(UpdateMemo event) async* {
    _memoRepository.updateMemo(event.updatedMemo);
  }

  Stream<MemoState> _mapDeleteMemoToState(DeleteMemo event) async* {
    _memoRepository.deleteMemo(event.memo);
  }

  Stream<MemoState> _mapMergeMemoToState(MergeMemo event) async* {
    var merged = event.memos.first;
    var content = merged.content;
    var contentStyle = SpannableList.fromJson(merged.contentStyle);
    var contentImages = <String>[]..addAll(merged.contentImages);
    for (var index = 1; index < event.memos.length; index++) {
      var memo = event.memos[index];
      content += memo.content;
      contentStyle.concat(SpannableList.fromJson(memo.contentStyle));
      contentImages.addAll(memo.contentImages);
      _memoRepository.deleteMemo(memo);
    }
    merged.content = content;
    merged.contentStyle = contentStyle.toJson();
    merged.contentImages = contentImages;
    _memoRepository.updateMemo(merged);
  }

  Stream<MemoState> _mapMemosUpdateToState(MemosUpdated event) async* {
    yield MemosLoaded(event.memos);
  }

  Stream<MemoState> _mapUpdateMemoUserToState(UpdateMemoUser event) async* {
    _memoRepository.updateUserId(event.userId);
    dispatch(LoadMemos());
  }
}
