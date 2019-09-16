import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fill_memo/model/folder.dart';
import 'package:fill_memo/repository/repository.dart';

class FirebaseFolderRepository extends FolderRepository {
  final folderCollection = Firestore.instance.collection(Folder.collectionName);
  String _userId;

  @override
  Future<void> addNewFolder(Folder folder) {
    folder.userId = _userId;
    return folderCollection.add(folder.toMap());
  }

  @override
  Future<void> deleteFolder(Folder folder) {
    return folderCollection.document(folder.id).delete();
  }

  @override
  Stream<List<Folder>> folders() {
    return folderCollection
        .where(Folder.columnUserId, isEqualTo: _userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((document) =>
              Folder.fromMap(document.data)..id = document.documentID)
          .toList();
    });
  }

  @override
  Future<void> updateFolder(Folder folder) {
    return folderCollection.document(folder.id).updateData(folder.toMap());
  }

  @override
  void updateUserId(String userId) => _userId = userId;
}
