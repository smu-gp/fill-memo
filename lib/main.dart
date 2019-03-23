import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/simple_bloc_delegate.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  bool isProduction = bool.fromEnvironment('dart.vm.product');
  if (!isProduction) {
    await Sqflite.devSetDebugModeOn(true);
    BlocSupervisor().delegate = SimpleBlocDelegate();
  }
  final db = await databaseProvider.database;
  runApp(App(
    historyRepository: LocalHistoryRepository(db),
    resultRepository: LocalResultRepository(db),
    folderRepository: LocalFolderRepository(db),
  ));
}
