import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/repository.dart';

class FirebaseFolderRepository extends FolderRepository {
  final UserRepository _userRepository;

  FirebaseFolderRepository({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  Future<String> get uid async {
    return (await _userRepository.getUser()).uid;
  }

  @override
  Future<Folder> create(Folder newFolder) async {
    if (newFolder.userId == null) {
      newFolder.userId = await uid;
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
        .where(Folder.columnUserId, isEqualTo: await uid)
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
