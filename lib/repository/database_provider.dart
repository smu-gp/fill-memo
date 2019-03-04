import 'dart:async';

import 'package:path/path.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';
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
    await db.execute('CREATE TABLE ${History.tableName} (' +
        '${History.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '${History.columnSourceImage} TEXT NOT NULL,' +
        '${History.columnCreatedAt} INTEGER NOT NULL,' +
        '${History.columnFolderId} INTEGER' +
        ')');
    await db.execute('CREATE TABLE ${Result.tableName} (' +
        '${Result.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '${Result.columnHistoryId} INTEGER NOT NULL,'
        '${Result.columnType} TEXT NOT NULL,' +
        '${Result.columnContent} TEXT NOT NULL' +
        ')');
    await db.execute('CREATE TABLE ${Folder.tableName} (' +
        '${Folder.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '${Folder.columnName} TEXT NOT NULL' +
        ')');
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future close() async => _database.close();
}
