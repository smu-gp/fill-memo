import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/bloc/result/result_event.dart';
import 'package:sp_client/bloc/result/result_state.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/repository.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final ResultRepository repository;

  ResultBloc({@required this.repository}) : assert(repository != null);

  @override
  ResultState get initialState => ResultLoading();

  @override
  Stream<ResultState> mapEventToState(
    ResultEvent event,
  ) async* {
    if (event is LoadResults) {
      yield* _mapLoadResultsToState(event);
    }
  }

  Stream<ResultState> _mapLoadResultsToState(LoadResults event) async* {
    try {
      final results = await repository.readByHistoryId(event.historyId);
      yield ResultLoaded(results);
    } catch (_) {
      yield ResultNotLoaded();
    }
  }

  void addResults(List<Result> results, int historyId) {
    results
        .forEach((result) => repository.create(result..historyId = historyId));
  }

  void deleteResults(int historyId) {
    repository.deleteByHistoryId(historyId);
  }
}
