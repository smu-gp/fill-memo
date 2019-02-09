import 'package:rxdart/rxdart.dart';
import 'package:sp_client/bloc/base_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/repository/base_repository.dart';

class HistoryBloc extends BaseBloc {
  final BaseRepository<History> _historyInteractor;
  final _dataFetcher = BehaviorSubject<List<History>>();
  final _sortOrderController = BehaviorSubject<SortOrder>(
    seedValue: SortOrder.createdAtDes,
    sync: true,
  );

  Observable<List<History>> get allData => _dataFetcher.stream;

  Observable<SortOrder> get activeSortOrder => _sortOrderController.stream;

  HistoryBloc(this._historyInteractor) {
    activeSortOrder.listen((sortOrder) => readAll());
  }

  Future<History> create(History newObject) {
    var created = _historyInteractor.create(newObject);
    readAll();
    return created;
  }

  Future<History> readById(int id) => _historyInteractor.readById(id);

  Future readAll() async {
    var orderBy = History.columnCreatedAt +
        (_sortOrderController.value == SortOrder.createdAtAsc
            ? ' ASC'
            : ' DESC');
    var list = await _historyInteractor.readAll(orderBy: orderBy);
    _dataFetcher.add(list);
  }

  Future<bool> delete(int id) {
    _dataFetcher.add(
      List.unmodifiable(_dataFetcher.value.fold<List<History>>(
        [],
        (prev, entity) {
          return id == entity.id ? prev : (prev..add(entity));
        },
      )),
    );
    return _historyInteractor.delete(id);
  }

  void updateSort(SortOrder order) => _sortOrderController.add(order);

  @override
  void dispose() {
    _dataFetcher.close();
    _sortOrderController.close();
  }
}
