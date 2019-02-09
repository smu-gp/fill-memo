import 'package:rxdart/rxdart.dart';
import 'package:sp_client/bloc/base_bloc.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/base_repository.dart';

class ResultBloc extends BaseBloc {
  final BaseResultRepository _resultRepository;
  final _dataFetcher = PublishSubject<List<Result>>();

  Observable<List<Result>> get allData => _dataFetcher.stream;

  ResultBloc(this._resultRepository);

  Future<Result> create(Result newObject) =>
      _resultRepository.create(newObject);

  Future<List<Result>> readByHistoryId(int historyId) =>
      _resultRepository.readByHistoryId(historyId);

  Future<int> deleteByHistoryId(int historyId) =>
      _resultRepository.deleteByHistoryId(historyId);

  @override
  dispose() {
    _dataFetcher.close();
  }
}
