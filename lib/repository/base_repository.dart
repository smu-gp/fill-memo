import 'package:sp_client/model/folder.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';

abstract class BaseHistoryRepository {
  Future<History> create(History newData);

  Future<History> readById(int id);

  Future<List<History>> readAll({String sortColumn, bool sortAscending = true});

  Future<bool> update(History history);

  Future<bool> delete(int id);
}

abstract class BaseResultRepository {
  Future<Result> create(Result newData);

  Future<Result> readById(int id);

  Future<List<Result>> readByHistoryId(int historyId);

  Future<bool> delete(int id);

  Future<int> deleteByHistoryId(int historyId);
}

abstract class BaseFolderRepository {
  Future<Folder> create(Folder newData);

  Future<List<Folder>> readAll();

  Future<bool> update(Folder folder);

  Future<bool> delete(int id);
}
