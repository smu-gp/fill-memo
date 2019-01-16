import 'package:sp_client/bloc/base_bloc.dart';
import 'package:sp_client/models.dart';
import 'package:sqflite/sqflite.dart';

class ResultBloc extends BaseBloc<Result> {
  ResultBloc(Database db) : super(db);

  @override
  Future<Result> create(Result newObject) async {
    newObject.id = await db.insert(Result.tableName, newObject.toMap());
    return newObject;
  }

  @override
  Future<Result> read(int id) async {
    var maps = await db.query(
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

  Future readByHistoryId(int historyId) async {
    var maps = await db.query(
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
    if (maps.length > 0) {
      var list = maps.map((map) => Result.fromMap(map)).toList();
      dataFetcher.sink.add(list);
    } else {
      dataFetcher.sink.add([]);
    }
  }

  @override
  Future readAll({String orderBy}) async {
    // No-op
  }

  @override
  Future<int> delete(int id) async {
    return await db.delete(
      Result.tableName,
      where: '${Result.columnId} = ?',
      whereArgs: [id],
    );
  }
}
