import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseMemoRepository extends MemoRepository {
  final String userId;

  FirebaseMemoRepository(this.userId) : assert(userId != null);

  @override
  Future<Memo> create(Memo newMemo) async {
    if (newMemo.userId == null) {
      newMemo.userId = userId;
    }
    Firestore.instance
        .collection(Memo.collectionName)
        .document()
        .setData(newMemo.toMap());
    return newMemo;
  }

  @override
  Future<List<Memo>> readAll() {
    throw UnsupportedError("readAll");
  }

  @override
  Stream<List<Memo>> readAllAsStream() async* {
    var queryStream = Firestore.instance
        .collection(Memo.collectionName)
        .where(Memo.columnUserId, isEqualTo: userId)
        .snapshots();
    await for (var queryData in queryStream) {
      yield queryData.documents
          .map((document) =>
              Memo.fromMap(document.data)..id = document.documentID)
          .toList();
    }
  }

  @override
  Future<List<Memo>> readByFolderId(String folderId) {
    throw UnsupportedError("readByFolderId");
  }

  @override
  Stream<List<Memo>> readByFolderIdAsStream(String folderId) async* {
    var queryStream = Firestore.instance
        .collection(Memo.collectionName)
        .where(Memo.columnUserId, isEqualTo: userId)
        .where(Memo.columnFolderId, isEqualTo: folderId)
        .snapshots();
    await for (var queryData in queryStream) {
      yield queryData.documents
          .map((document) =>
              Memo.fromMap(document.data)..id = document.documentID)
          .toList();
    }
  }

  @override
  Future<Memo> readById(String id) {
    throw UnsupportedError("readById");
  }

  @override
  Stream<Memo> readByIdAsStream(String id) async* {
    var queryStream = Firestore.instance
        .collection(Memo.collectionName)
        .document(id)
        .snapshots();
    await for (var queryData in queryStream) {
      if (queryData.exists) {
        yield Memo.fromMap(queryData.data)..id = queryData.documentID;
      } else {
        yield null;
      }
    }
  }

  @override
  Future<bool> update(Memo memo) async {
    Firestore.instance
        .collection(Memo.collectionName)
        .document(memo.id)
        .updateData(memo.toMap());
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    Firestore.instance.collection(Memo.collectionName).document(id).delete();
    return true;
  }
}
