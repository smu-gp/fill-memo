import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/simple_bloc_delegate.dart';
import 'package:sp_client/repository/firebase/user_repository.dart';
import 'package:sp_client/repository/repositories.dart';

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    Crashlytics.instance.enableInDevMode = true;
    BlocSupervisor.delegate = SimpleBlocDelegate();
  } else {
    FlutterError.onError = (FlutterErrorDetails details) {
      Crashlytics.instance.onError(details);
    };
  }

  final sharedPreferences = await SharedPreferences.getInstance();
  final userRepository = FirebaseUserRepository();
  runApp(App(
    preferenceRepository: LocalPreferenceRepository(sharedPreferences),
    userRepository: userRepository,
    memoRepository: FirebaseMemoRepository(userRepository: userRepository),
    folderRepository: FirebaseFolderRepository(userRepository: userRepository),
  ));
}
