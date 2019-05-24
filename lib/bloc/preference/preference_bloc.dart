import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/preference.dart';
import 'package:sp_client/model/preferences.dart';
import 'package:sp_client/repository/repositories.dart';

import './preference_event.dart';
import './preference_state.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  final PreferenceRepository repository;

  /// The list of [Preference] usage in bloc
  final List<Preference> _usagePreferences;

  PreferenceBloc({
    @required this.repository,
    @required List<Preference> usagePreferences,
  })  : _usagePreferences = usagePreferences,
        assert(repository != null),
        assert(usagePreferences != null);

  @override
  PreferenceState get initialState => _loadPreferences();

  @override
  Stream<PreferenceState> mapEventToState(PreferenceEvent event) async* {
    if (event is UpdatePreference) {
      var updatedPreference = event.updatedPreference;
      await _setPreference(updatedPreference);
      yield _loadPreferences();
    }
  }

  PreferenceState _loadPreferences() {
    var preferencesMap = Map<String, Preference>();
    _usagePreferences
        .map((preference) => _getPreference(preference))
        .forEach((preference) => preferencesMap[preference.key] = preference);
    var updatedTime = DateTime.now().millisecondsSinceEpoch;
    return PreferenceState(
      updatedTime: updatedTime,
      preferences: Preferences(preferencesMap),
    );
  }

  /// Returns filled value [Preference] by [Preference] from [SharedPreferences]
  Preference _getPreference(Preference preference) {
    var preferenceType = preference.typeOfPreference();
    if (preferenceType == int) {
      preference.value = repository.getInt(preference.key);
    } else if (preferenceType == String) {
      preference.value = repository.getString(preference.key);
    } else if (preferenceType == bool) {
      preference.value = repository.getBool(preference.key);
    }
    if (preference.value == null) {
      preference.value = preference.initValue;
    }
    return preference;
  }

  Future _setPreference(Preference preference) async {
    var preferenceType = preference.typeOfPreference();
    if (preferenceType == int) {
      await repository.setInt(preference.key, preference.value);
    } else if (preferenceType == String) {
      await repository.setString(preference.key, preference.value);
    } else if (preferenceType == bool) {
      await repository.setBool(preference.key, preference.value);
    }
  }

  /// Returns [Preference] by key from [Preferences] in [PreferenceState]
  Preference<T> getPreference<T>(String key) {
    return currentState.preferences.get<T>(key);
  }
}
