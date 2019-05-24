import 'package:sp_client/model/models.dart';

class AppPreferences {
  static final String keyUserId = "pref_user_id";

  static final String keyLightTheme = "pref_light_theme";

  // For debug options
  static final String keyUseLocalDummy = "pref_use_local_dummy";
  static final String keyServiceHost = "pref_service_host";
  static final String keyOverlayHandleRange = "pref_overlay_handle_range";

  static final String initServiceHost = "127.0.0.1";

  static final List<Preference> preferences = [
    Preference<String>(
      key: keyUserId,
      initValue: null,
    ),
    Preference<bool>(
      key: keyLightTheme,
      initValue: false,
    ),
    Preference<bool>(
      key: keyUseLocalDummy,
      initValue: false,
    ),
    Preference<String>(
      key: keyServiceHost,
      initValue: initServiceHost,
    ),
    Preference<bool>(
      key: keyOverlayHandleRange,
      initValue: false,
    )
  ];
}
