import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class ResultRepository implements BaseResultRepository {
  final Database _db;

  ResultRepository(this._db);

  @override
  Future<Result> create(Result newData) async {
    newData.id = await _db.insert(Result.tableName, newData.toMap());
    return newData;
  }

  @override
  Future<Result> readById(int id) async {
    var maps = await _db.query(
      Result.tableName,
      columns: [
        Result.columnId,
        Result.columnHistoryId,
        Result.columnType,
        Result.columnContent,
      ],
      where: '${Result.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Result.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Result>> readByHistoryId(int historyId) async {
    var maps = await _db.query(
      Result.tableName,
      columns: [
        Result.columnId,
        Result.columnHistoryId,
        Result.columnType,
        Result.columnContent,
      ],
      where: '${Result.columnHistoryId} = ?',
      whereArgs: [historyId],
    );
    return (maps.length > 0
        ? maps.map((map) => Result.fromMap(map)).toList()
        : []);
  }

  @override
  Future<List<Result>> readAll({String orderBy}) async {
    var maps = await _db.query(
      Result.tableName,
      columns: [
        Result.columnId,
        Result.columnHistoryId,
        Result.columnType,
        Result.columnContent,
      ],
      orderBy: orderBy,
    );
    return (maps.length > 0
        ? maps.map((map) => Result.fromMap(map)).toList()
        : []);
  }

  @override
  Future<int> deleteByHistoryId(int historyId) async {
    var deleted = await _db.delete(
      Result.tableName,
      where: '${Result.columnHistoryId} = ?',
      whereArgs: [historyId],
    );
    return deleted;
  }

  @override
  Future<bool> delete(int id) async {
    var deleted = await _db.delete(
      Result.tableName,
      where: '${Result.columnId} = ?',
      whereArgs: [id],
    );
    return (deleted > 0);
  }
}
