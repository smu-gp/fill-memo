import 'package:rxdart/rxdart.dart';
import 'package:sp_client/bloc/base_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/repository/base_repository.dart';

class HistoryBloc extends BaseBloc {
  final BaseRepository<History> _historyRepository;
  final _dataFetcher = BehaviorSubject<List<History>>();
  final _sortOrderController = BehaviorSubject<SortOrder>(
    seedValue: SortOrder.createdAtDes,
    sync: true,
  );

  Observable<List<History>> get allData => _dataFetcher.stream;

  Observable<SortOrder> get activeSortOrder => _sortOrderController.stream;

  HistoryBloc(this._historyRepository) {
    activeSortOrder.listen((sortOrder) => readAll());
  }

  Future<History> create(History newObject) {
    var created = _historyRepository.create(newObject);
    readAll();
    return created;
  }

  Future<History> readById(int id) => _historyRepository.readById(id);

  Future readAll() async {
    var orderBy = History.columnCreatedAt +
        (_sortOrderController.value == SortOrder.createdAtAsc
            ? ' ASC'
            : ' DESC');
    var list = await _historyRepository.readAll(orderBy: orderBy);
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
    return _historyRepository.delete(id);
  }

  void updateSort(SortOrder order) => _sortOrderController.add(order);

  @override
  void dispose() {
    _dataFetcher.close();
    _sortOrderController.close();
  }
}
