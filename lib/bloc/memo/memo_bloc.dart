import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/repository/repositories.dart';

import './bloc.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  MemoRepository repository;

  MemoBloc(this.repository) : assert(repository != null);

  @override
  MemoState get initialState => MemoLoading();

  @override
  Stream<MemoState> mapEventToState(
    MemoEvent event,
  ) async* {
    if (event is ReadMemo) {
      yield* _mapReadMemoToState(event);
    }
  }

  Stream<MemoState> _mapReadMemoToState(ReadMemo event) async* {
    try {
      await for (var list in repository.readAllAsStream()) {
        yield MemoLoaded(list);
      }
    } catch (exception) {
      yield MemoNotLoaded(exception);
    }
  }

  Future<Memo> createMemo(Memo newMemo) async {
    return repository.create(newMemo);
  }

  Stream<Memo> readMemo(String id) {
    return repository.readByIdAsStream(id);
  }

  void mergeMemo(List<Memo> mergeMemos) {
    var mergedMemo = mergeMemos.first;
    var mergedContent = "";
    mergeMemos.asMap().forEach((index, memo) {
      mergedContent += memo.content;
      if (index != mergeMemos.length - 1) mergedContent += "\n";
      repository.delete(memo.id);
    });
    mergedMemo.content = mergedContent;
    repository.create(mergedMemo);
  }

  void updateMemo(Memo updatedMemo) {
    repository.update(updatedMemo);
  }

  void deleteMemo(String id) {
    repository.delete(id);
  }
}
