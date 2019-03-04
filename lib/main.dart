import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sqflite/sqflite.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    await Sqflite.devSetDebugModeOn(true);
    BlocSupervisor().delegate = SimpleBlocDelegate();
  }
  final db = await databaseProvider.database;
  runApp(App(
    historyRepository: HistoryRepository(db),
    resultRepository: ResultRepository(db),
    folderRepository: FolderRepository(db),
  ));
}
