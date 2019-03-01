import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/base_repository.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  final BaseResultRepository resultRepository;

  ResultBloc({@required this.resultRepository})
      : assert(resultRepository != null);

  @override
  ResultState get initialState => ResultLoading();

  @override
  Stream<ResultState> mapEventToState(
    ResultState currentState,
    ResultEvent event,
  ) async* {
    if (event is FetchResult) {
      var list = await resultRepository.readByHistoryId(event.historyId);
      yield (list.isNotEmpty ? ResultLoaded(results: list) : ResultEmpty());
    }
  }

  Future<Result> createResult(Result newObject) =>
      resultRepository.create(newObject);

  Future<int> deleteResultByHistoryId(int historyId) =>
      resultRepository.deleteByHistoryId(historyId);
}

abstract class ResultEvent extends Equatable {
  ResultEvent([List props = const []]) : super(props);
}

class FetchResult extends ResultEvent {
  final int historyId;

  FetchResult({@required this.historyId})
      : assert(historyId != null),
        super([historyId]);
}

abstract class ResultState extends Equatable {
  ResultState([List props = const []]) : super(props);
}

class ResultEmpty extends ResultState {}

class ResultLoading extends ResultState {}

class ResultLoaded extends ResultState {
  final List<Result> results;

  ResultLoaded({@required this.results})
      : assert(results != null),
        super([results]);
}
