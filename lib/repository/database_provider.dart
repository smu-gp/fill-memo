import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final DatabaseProvider databaseProvider = DatabaseProvider._();

class DatabaseProvider {
  static Database _database;

  DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDB();
    return _database;
  }

  Future _initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  _onCreate(Database db, int version) async {
    // Not support DateTime. Use millisSinceEpoch to int
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future close() async => _database.close();
}
