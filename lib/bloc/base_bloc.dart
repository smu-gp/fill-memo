import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseBloc<T> {
  final Database db;
  final dataFetcher = PublishSubject<List<T>>();

  Observable<List<T>> get allData => dataFetcher.stream;

  BaseBloc(this.db);

  Future<T> create(T newObject);

  Future<T> read(int id);

  Future readAll({String orderBy});

  Future<int> delete(int id);

  dispose() {
    dataFetcher.close();
  }
}
