import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseMemoRepository extends MemoRepository {
  final memoCollection = Firestore.instance.collection(Memo.collectionName);
  final String userId;

  FirebaseMemoRepository(this.userId) : assert(userId != null);

  @override
  Future<void> addNewMemo(Memo memo) async {
    memo.userId = userId;
    return memoCollection.add(memo.toMap());
  }

  @override
  Future<void> deleteMemo(Memo memo) {
    return memoCollection.document(memo.id).delete();
  }

  @override
  Stream<List<Memo>> memos() {
    return memoCollection
        .where(Memo.columnUserId, isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((document) =>
              Memo.fromMap(document.data)..id = document.documentID)
          .toList();
    });
  }

  @override
  Future<void> updateMemo(Memo memo) {
    return memoCollection.document(memo.id).updateData(memo.toMap());
  }
}
