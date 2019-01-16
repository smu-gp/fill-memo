import 'package:flutter/material.dart';
import 'package:sp_client/app.dart';
import 'package:sp_client/bloc/db_provider.dart';
import 'package:sp_client/dependency_injection.dart';

void main() async {
  var db = await dbProvider.database;
  runApp(Injector(
    database: db,
    child: App(),
  ));
}
