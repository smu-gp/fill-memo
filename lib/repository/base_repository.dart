import 'package:sp_client/model/result.dart';

abstract class BaseRepository<T> {
  Future<T> create(T newData);

  Future<T> readById(int id);

  Future<List<T>> readAll({String orderBy});

  Future<bool> delete(int id);
}

abstract class BaseResultRepository extends BaseRepository<Result> {
  Future<List<Result>> readByHistoryId(int historyId);

  Future<int> deleteByHistoryId(int historyId);
}
