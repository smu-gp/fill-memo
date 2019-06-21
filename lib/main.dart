import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'app.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'repository/repositories.dart';

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    await Sqflite.devSetDebugModeOn(true);
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }
  final db = await databaseProvider.database;
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(App(
    historyRepository: LocalHistoryRepository(db),
    resultRepository: LocalResultRepository(db),
    folderRepository: LocalFolderRepository(db),
    preferenceRepository: LocalPreferenceRepository(sharedPreferences),
  ));
}
