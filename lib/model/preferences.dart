import 'package:sp_client/model/preference.dart';

/// A wrapper class for preference lists.
class Preferences {
  final Map<String, Preference> _preferences;

  const Preferences(this._preferences);

  /// Get preference from lists
  Preference<T> get<T>(String key) {
    assert(key != null);
    return _preferences.containsKey(key) ? _preferences[key] : null;
  }
}
