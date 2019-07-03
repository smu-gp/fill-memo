import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/simple_bloc_delegate.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    // ignore: deprecated_member_use
    await Sqflite.devSetDebugModeOn(true);
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(App(
    preferenceRepository: LocalPreferenceRepository(sharedPreferences),
  ));
}
