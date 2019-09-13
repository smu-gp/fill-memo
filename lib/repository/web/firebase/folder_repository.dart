import 'package:firebase/firebase.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseFolderRepository extends FolderRepository {
  final folderCollection = firestore().collection(Folder.collectionName);
  String _userId;

  @override
  Future<void> addNewFolder(Folder folder) {
    folder.userId = _userId;
    return folderCollection.add(folder.toMap());
  }

  @override
  Future<void> deleteFolder(Folder folder) {
    return folderCollection.doc(folder.id).delete();
  }

  @override
  Stream<List<Folder>> folders() {
    return folderCollection
        .where(Folder.columnUserId, '==', _userId)
        .onSnapshot
        .map((snapshot) {
      return snapshot.docs
          .map((document) => Folder.fromMap(document.data())..id = document.id)
          .toList();
    });
  }

  @override
  Future<void> updateFolder(Folder folder) {
    return folderCollection.doc(folder.id).update(data: folder.toMap());
  }

  @override
  void updateUserId(String userId) => _userId = userId;
}
