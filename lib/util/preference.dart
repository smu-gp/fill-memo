import 'package:preference_helper/preference_helper.dart';

class AppPreferences {
  static final String keyUseLocalDummy = "pref_use_local_dummy";
  static final String keyServiceUrl = "pref_service_url";
  static final String keyOverlayHandleRange = "pref_overlay_handle_range";

  static final String initServiceUrl = "http://127.0.0.1:3000";

  static final List<Preference> preferences = [
    Preference<bool>(
      key: keyUseLocalDummy,
      initValue: false,
    ),
    Preference<String>(
      key: keyServiceUrl,
      initValue: initServiceUrl,
    ),
    Preference<bool>(
      key: keyOverlayHandleRange,
      initValue: false,
    )
  ];
}
