import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/bloc/history/history_event.dart';
import 'package:sp_client/bloc/history/history_state.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/repository/repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository repository;

  HistoryBloc({@required this.repository}) : assert(repository != null);

  @override
  HistoryState get initialState => HistoryLoading();

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    if (event is LoadHistory) {
      yield* _mapLoadHistoryToState(event);
    } else if (event is UpdateHistory) {
      yield* _mapUpdateHistoryToState(currentState, event);
    } else if (event is DeleteHistory) {
      yield* _mapDeleteHistoryToState(currentState, event);
    }
  }

  Stream<HistoryState> _mapLoadHistoryToState(LoadHistory event) async* {
    yield* _loadHistory(event.order);
  }

  Stream<HistoryState> _mapUpdateHistoryToState(
    HistoryState currentState,
    UpdateHistory event,
  ) async* {
    if (currentState is HistoryLoaded) {
      repository.update(event.updatedHistory);
      yield* _loadHistory(currentState.order);
    }
  }

  Stream<HistoryState> _mapDeleteHistoryToState(
    HistoryState currentState,
    DeleteHistory event,
  ) async* {
    if (currentState is HistoryLoaded) {
      repository.delete(event.id);
      yield* _loadHistory(currentState.order);
    }
  }

  Stream<HistoryState> _loadHistory(SortOrder order) async* {
    try {
      var histories = await repository.readAll(
        sortColumn: History.columnCreatedAt,
        sortAscending: order == SortOrder.createdAtAsc,
      );
      yield HistoryLoaded(histories: histories, order: order);
    } catch (_) {
      yield HistoryNotLoaded();
    }
  }

  Future<History> createHistory(History newHistory) {
    var state = currentState;
    if (state is HistoryLoaded) {
      var created = repository.create(newHistory);
      dispatch(LoadHistory(state.order));
      return created;
    } else {
      return null;
    }
  }
}
