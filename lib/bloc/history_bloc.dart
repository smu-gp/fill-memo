import 'package:rxdart/rxdart.dart';
import 'package:sp_client/models.dart';
import 'package:sqflite/sqflite.dart';

class HistoryBloc {
  final Database _db;
  final dataFetcher = PublishSubject<List<History>>();

  Observable<List<History>> get allData => dataFetcher.stream;

  HistoryBloc(this._db);

  Future<History> create(History newObject) async {
    newObject.id = await _db.insert(History.tableName, newObject.toMap());
    return newObject;
  }

  Future<History> read(int id) async {
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

  void readAll({String orderBy}) async {
    var maps = await _db.query(
      History.tableName,
      columns: [
        History.columnId,
        History.columnSourceImage,
        History.columnCreatedAt,
      ],
      orderBy: orderBy,
    );
    if (maps.length > 0) {
      var list = maps.map((map) => History.fromMap(map)).toList();
      dataFetcher.sink.add(list);
    } else {
      dataFetcher.sink.add([]);
    }
  }

  Future<int> delete(int id) async {
    return await _db.delete(
      History.tableName,
      where: '${History.columnId} = ?',
      whereArgs: [id],
    );
  }

  void dispose() {
    dataFetcher.close();
  }
}
