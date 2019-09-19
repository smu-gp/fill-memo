import 'package:bloc/bloc.dart';
import 'package:fill_memo/app.dart';
import 'package:fill_memo/bloc/simple_bloc_delegate.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  AppConfig appConfig;
  PreferenceRepository preferenceRepository;

  if (kIsWeb) {
    appConfig = AppConfig();
    preferenceRepository = LocalPreferenceRepository();
  } else {
    bool isProduction = bool.fromEnvironment('dart.vm.product');
    if (!isProduction) {
      Crashlytics.instance.enableInDevMode = true;
      BlocSupervisor.delegate = SimpleBlocDelegate();
    } else {
      FlutterError.onError = Crashlytics.instance.recordFlutterError;
    }

    WidgetsFlutterBinding.ensureInitialized();

    LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    bool useFingerprint = false;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        useFingerprint = true;
      }
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    appConfig = AppConfig(useFingerprint: useFingerprint);
    preferenceRepository = LocalPreferenceRepository(sharedPreferences);
  }
  runApp(App(
    config: appConfig,
    preferenceRepository: preferenceRepository,
  ));
}
