import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/repository/repository.dart';

class LocalPreferenceRepository implements PreferenceRepository {
  final SharedPreferences _sharedPreferences;

  LocalPreferenceRepository([this._sharedPreferences]);

  @override
  bool getBool(String key) {
    return _sharedPreferences.getBool(key);
  }

  @override
  int getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  @override
  String getString(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }
}
