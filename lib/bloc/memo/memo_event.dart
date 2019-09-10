import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class MemoEvent extends Equatable {
  MemoEvent([List props = const []]) : super(props);
}

class LoadMemos extends MemoEvent {
  @override
  String toString() => '$runtimeType';
}

class AddMemo extends MemoEvent {
  final Memo memo;

  AddMemo(this.memo) : super([memo]);

  @override
  String toString() => '$runtimeType(memo: $memo)';
}

class UpdateMemo extends MemoEvent {
  final Memo updatedMemo;

  UpdateMemo(this.updatedMemo) : super([updatedMemo]);

  @override
  String toString() => '$runtimeType(updatedMemo: $updatedMemo)';
}

class DeleteMemo extends MemoEvent {
  final Memo memo;

  DeleteMemo(this.memo) : super([memo]);

  @override
  String toString() => '$runtimeType(memo: $memo)';
}

class MergeMemo extends MemoEvent {
  final String type;
  final List<Memo> memos;

  MergeMemo(this.type, this.memos);

  @override
  String toString() => '$runtimeType(type: $type, memos: $memos)';
}

class MemosUpdated extends MemoEvent {
  final List<Memo> memos;

  MemosUpdated(this.memos);

  @override
  String toString() => '$runtimeType';
}

class UpdateMemoUser extends MemoEvent {
  final String userId;

  UpdateMemoUser(this.userId) : super([userId]);

  @override
  String toString() => '$runtimeType(userId: $userId)';
}
