import 'package:sp_client/model/history.dart';
import 'package:sp_client/repository/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class HistoryRepository implements BaseHistoryRepository {
  final Database _db;

  HistoryRepository(this._db);

  @override
  Future<History> create(History newData) async {
    newData.id = await _db.insert(History.tableName, newData.toMap());
    return newData;
  }

  @override
  Future<History> readById(int id) async {
    var maps = await _db.query(
      History.tableName,
      columns: [
        History.columnId,
        History.columnSourceImage,
        History.columnCreatedAt,
      ],
      where: '${History.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return History.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<History>> readAll(
      {String sortColumn, bool sortAscending = true}) async {
    var maps = await _db.query(
      History.tableName,
      columns: [
        History.columnId,
        History.columnSourceImage,
        History.columnCreatedAt,
      ],
      orderBy: '$sortColumn ${sortAscending ? "ASC" : "DESC"}',
    );
    return (maps.length > 0
        ? maps.map((map) => History.fromMap(map)).toList()
        : []);
  }

  @override
  Future<bool> delete(int id) async {
    var deleted = await _db.delete(
      History.tableName,
      where: '${History.columnId} = ?',
      whereArgs: [id],
    );
    return (deleted > 0);
  }
}
