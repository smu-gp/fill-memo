import 'package:sp_client/bloc/base_bloc.dart';
import 'package:sp_client/models.dart';
import 'package:sqflite/sqflite.dart';

class HistoryBloc extends BaseBloc<History> {
  HistoryBloc(Database db) : super(db);

  @override
  Future<History> create(History newObject) async {
    newObject.id = await db.insert(History.tableName, newObject.toMap());
    return newObject;
  }

  @override
  Future<History> read(int id) async {
    var maps = await db.query(
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
  Future readAll({String orderBy}) async {
    var maps = await db.query(
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

  @override
  Future<int> delete(int id) async {
    return await db.delete(
      History.tableName,
      where: '${History.columnId} = ?',
      whereArgs: [id],
    );
  }
}
