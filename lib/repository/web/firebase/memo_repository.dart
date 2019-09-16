import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseMemoRepository extends MemoRepository {
  final memoCollection = firestore().collection(Memo.collectionName);
  String _userId;

  @override
  Future<void> addNewMemo(Memo memo) async {
    memo.userId = _userId;
    return memoCollection.add(memo.toMap());
  }

  @override
  Future<void> deleteMemo(Memo memo) {
    return memoCollection.doc(memo.id).delete();
  }

  @override
  Stream<List<Memo>> memos() {
    return memoCollection
        .where(Memo.columnUserId, '==', _userId)
        .onSnapshot
        .map((snapshot) {
      return snapshot.docs
          .map((document) => Memo.fromMap(document.data())..id = document.id)
          .toList();
    });
  }

  @override
  Future<void> updateMemo(Memo memo) {
    return memoCollection.doc(memo.id).update(data: memo.toMap());
  }

  @override
  void updateUserId(String userId) => _userId = userId;
}
