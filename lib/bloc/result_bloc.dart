import 'package:rxdart/rxdart.dart';
import 'package:sp_client/models.dart';
import 'package:sqflite/sqflite.dart';

class ResultBloc {
  final Database _db;
  final dataFetcher = PublishSubject<List<Result>>();

  Observable<List<Result>> get allData => dataFetcher.stream;

  ResultBloc(this._db);

  Future<Result> create(Result newObject) async {
    newObject.id = await _db.insert(Result.tableName, newObject.toMap());
    return newObject;
  }

  Future readByHistoryId(int historyId) async {
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
    if (maps.length > 0) {
      var list = maps.map((map) => Result.fromMap(map)).toList();
      dataFetcher.sink.add(list);
    } else {
      dataFetcher.sink.add([]);
    }
  }

  Future<int> deleteByHistoryId(int historyId) async {
    return await _db.delete(
      Result.tableName,
      where: '${Result.columnHistoryId} = ?',
      whereArgs: [historyId],
    );
  }

  dispose() {
    dataFetcher.close();
  }
}
