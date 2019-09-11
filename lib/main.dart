import 'package:bloc/bloc.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/simple_bloc_delegate.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/repository/web/local/preference_repository.dart';
import 'package:sp_client/util/config.dart';

void main() async {
  if (kIsWeb) {
    fb.initializeApp(
      apiKey: 'AIzaSyAgVki9oTGUgsScsVa5cWZWiVn6Ss6NPho',
      authDomain: 'smu-gp.firebaseapp.com',
      databaseURL: "https://smu-gp.firebaseio.com",
      storageBucket: "smu-gp.appspot.com",
      projectId: 'smu-gp',
    );

    runApp(App(
      config: AppConfig(),
      preferenceRepository: LocalWebPreferenceRepository(),
    ));
  } else {
    bool isProduction = bool.fromEnvironment('dart.vm.product');
    if (!isProduction) {
      Crashlytics.instance.enableInDevMode = true;
      BlocSupervisor.delegate = SimpleBlocDelegate();
    } else {
      FlutterError.onError = Crashlytics.instance.recordFlutterError;
    }

    WidgetsFlutterBinding.ensureInitialized();

    //  LocalAuthentication localAuth = LocalAuthentication();
//  bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    bool useFingerprint = false;
//  if (canCheckBiometrics) {
//    List<BiometricType> availableBiometrics =
//        await localAuth.getAvailableBiometrics();
//    if (availableBiometrics.contains(BiometricType.fingerprint)) {
//      useFingerprint = true;
//    }
//  }

    final sharedPreferences = await SharedPreferences.getInstance();
    runApp(App(
      config: AppConfig(
        useFingerprint: useFingerprint,
      ),
      preferenceRepository: LocalPreferenceRepository(sharedPreferences),
    ));
  }
}
