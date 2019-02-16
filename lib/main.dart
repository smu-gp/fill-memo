import 'package:flutter/material.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/repository/database_builder.dart';
import 'package:sp_client/repository/history_repository.dart';
import 'package:sp_client/repository/result_repository.dart';

void main() async {
  final db = await databaseBuilder.database;
  runApp(App(
    historyRepository: HistoryRepository(db),
    resultRepository: ResultRepository(db),
  ));
}
