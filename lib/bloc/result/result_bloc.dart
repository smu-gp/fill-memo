import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/bloc/result/result_event.dart';
import 'package:sp_client/bloc/result/result_state.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/repository.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final ResultRepository resultRepository;

  ResultBloc({@required this.resultRepository})
      : assert(resultRepository != null);

  @override
  ResultState get initialState => ResultLoading();

  @override
  Stream<ResultState> mapEventToState(
    ResultState currentState,
    ResultEvent event,
  ) async* {
    if (event is LoadResults) {
      yield* _mapLoadResultsToState(event);
    }
  }

  Stream<ResultState> _mapLoadResultsToState(LoadResults event) async* {
    try {
      final results = await resultRepository.readByHistoryId(event.historyId);
      yield ResultLoaded(results);
    } catch (_) {
      yield ResultNotLoaded();
    }
  }

  void addResults(List<Result> results, int historyId) {
    results.forEach(
        (result) => resultRepository.create(result..historyId = historyId));
  }

  void deleteResults(int historyId) {
    resultRepository.deleteByHistoryId(historyId);
  }
}
