import 'package:preference_helper/preference_helper.dart';

class AppPreferences {
  static final String keyDebugMode = "pref_debug_mode";
  static final String keyUseLocalDummy = "pref_use_local_dummy";
  static final String keyServiceUrl = "pref_service_url";

  static final String initServiceUrl = "http://127.0.0.1:3000";

  static final List<Preference> preferences = [
    Preference<bool>(
      key: keyDebugMode,
      initValue: false,
    ),
    Preference<bool>(
      key: keyUseLocalDummy,
      initValue: false,
    ),
    Preference<String>(
      key: keyServiceUrl,
      initValue: initServiceUrl,
    ),
  ];
}
