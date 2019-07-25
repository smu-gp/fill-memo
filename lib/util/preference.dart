import 'package:sp_client/model/models.dart';

import 'constants.dart';

class AppPreferences {
  static final String keyUserId = "pref_user_id";
  static final String keyDarkMode = "pref_dark_mode";

  // For debug options
  static final String keyServiceHost = "pref_service_host";

  static final List<Preference> preferences = [
    Preference<String>(
      key: keyUserId,
      initValue: null,
    ),
    Preference<bool>(
      key: keyDarkMode,
      initValue: false,
    ),
    Preference<String>(
      key: keyServiceHost,
      initValue: processServiceBaseUrl,
    ),
  ];
}
