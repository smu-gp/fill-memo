import 'package:sp_client/repository/repositories.dart';

class LocalWebPreferenceRepository implements PreferenceRepository {
  Map<String, dynamic> storage = Map();

  LocalWebPreferenceRepository();

  @override
  bool getBool(String key) {
    return storage[key] == "true";
  }

  @override
  int getInt(String key) {
    return int.parse(storage[key]);
  }

  @override
  String getString(String key) {
    return storage[key];
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    storage[key] = value ? "true" : "false";
    return false;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    storage[key] = value.toString();
    return false;
  }

  @override
  Future<bool> setString(String key, String value) async {
    storage[key] = value;
    return false;
  }
}
