import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_client/model/folder.dart';

import '../repository.dart';

class FirebaseFolderRepository extends FolderRepository {
  final String userId;

  FirebaseFolderRepository(this.userId) : assert(userId != null);

  @override
  Future<Folder> create(Folder newFolder) async {
    if (newFolder.userId == null) {
      newFolder.userId = userId;
    }
    Firestore.instance
        .collection(Folder.collectionName)
        .document()
        .setData(newFolder.toMap());
    return newFolder;
  }

  @override
  Future<List<Folder>> readAll() {
    throw UnsupportedError("readAll");
  }

  @override
  Stream<List<Folder>> readAllAsStream() async* {
    var queryStream = Firestore.instance
        .collection(Folder.collectionName)
        .where(Folder.columnUserId, isEqualTo: userId)
        .snapshots();
    await for (var queryData in queryStream) {
      yield queryData.documents
          .map((document) =>
              Folder.fromMap(document.data)..id = document.documentID)
          .toList();
    }
  }

  @override
  Future<bool> update(Folder folder) async {
    Firestore.instance
        .collection(Folder.collectionName)
        .document(folder.id)
        .updateData(folder.toMap());
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    Firestore.instance.collection(Folder.collectionName).document(id).delete();
    return true;
  }
}
