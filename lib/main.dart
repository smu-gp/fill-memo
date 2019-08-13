import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/simple_bloc_delegate.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/util/config.dart';

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    Crashlytics.instance.enableInDevMode = true;
    BlocSupervisor.delegate = SimpleBlocDelegate();
  } else {
    FlutterError.onError = Crashlytics.instance.recordFlutterError;
  }

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
  runApp(App(
    config: AppConfig(
      useFingerprint: useFingerprint,
    ),
    preferenceRepository: LocalPreferenceRepository(sharedPreferences),
  ));
}
