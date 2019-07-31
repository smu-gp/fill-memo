import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseFolderRepository extends FolderRepository {
  final folderCollection = Firestore.instance.collection(Folder.collectionName);
  final String userId;

  FirebaseFolderRepository(this.userId) : assert(userId != null);

  @override
  Future<void> addNewFolder(Folder folder) {
    folder.userId = userId;
    return folderCollection.add(folder.toMap());
  }

  @override
  Future<void> deleteFolder(Folder folder) {
    return folderCollection.document(folder.id).delete();
  }

  @override
  Stream<List<Folder>> folders() {
    return folderCollection
        .where(Folder.columnUserId, isEqualTo: userId)
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
}
