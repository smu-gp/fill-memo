import 'package:sp_client/model/models.dart';

abstract class MemoRepository {
  Future<Memo> create(Memo newMemo);

  Future<List<Memo>> readAll();

  Stream<List<Memo>> readAllAsStream();

  Future<List<Memo>> readByFolderId(String folderId);

  Stream<List<Memo>> readByFolderIdAsStream(String folderId);

  Future<Memo> readById(String id);

  Stream<Memo> readByIdAsStream(String id);

  Future<bool> update(Memo memo);

  Future<bool> delete(String id);
}

abstract class FolderRepository {
  Future<Folder> create(Folder newFolder);

  Future<List<Folder>> readAll();

  Stream<List<Folder>> readAllAsStream();

  Future<bool> update(Folder folder);

  Future<bool> delete(String id);
}

abstract class PreferenceRepository {
  String getString(String key);

  bool getBool(String key);

  int getInt(String key);

  Future<bool> setString(String key, String value);

  Future<bool> setBool(String key, bool value);

  Future<bool> setInt(String key, int value);
}

abstract class UserRepository {
  Future<User> signIn(String uid);

  Future signOut();

  Future<bool> isSignedIn();

  Future<User> getUser();

  Future<User> updateProfile({String displayName, String email});
}
