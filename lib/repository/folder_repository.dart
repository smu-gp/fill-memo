import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/base_repository.dart';
import 'package:sqflite/sqflite.dart';

class FolderRepository implements BaseFolderRepository {
  final Database _db;

  FolderRepository(this._db);

  @override
  Future<Folder> create(Folder newData) async {
    newData.id = await _db.insert(Folder.tableName, newData.toMap());
    return newData;
  }

  @override
  Future<List<Folder>> readAll() async {
    var maps = await _db.query(
      Folder.tableName,
      columns: [
        Folder.columnId,
        Folder.columnName,
      ],
    );
    return (maps.length > 0
        ? maps.map((map) => Folder.fromMap(map)).toList()
        : []);
  }

  @override
  Future<bool> update(Folder folder) async {
    var updated = await _db.update(
      Folder.tableName,
      folder.toMap(),
      where: '${Folder.columnId} = ?',
      whereArgs: [folder.id],
    );
    return (updated > 0);
  }

  @override
  Future<bool> delete(int id) async {
    var deleted = await _db.delete(
      Folder.tableName,
      where: '${Folder.columnId} = ?',
      whereArgs: [id],
    );
    return (deleted > 0);
  }
}
