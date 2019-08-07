import 'package:sp_client/model/models.dart';

abstract class MemoRepository {
  Future<void> addNewMemo(Memo memo);

  Future<void> deleteMemo(Memo memo);

  Stream<List<Memo>> memos();

  Future<void> updateMemo(Memo memo);

  void updateUserId(String userId);
}

abstract class FolderRepository {
  Future<void> addNewFolder(Folder folder);

  Future<void> deleteFolder(Folder folder);

  Stream<List<Folder>> folders();

  Future<void> updateFolder(Folder folder);

  void updateUserId(String userId);
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
