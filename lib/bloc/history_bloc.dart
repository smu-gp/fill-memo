import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/repository/base_repository.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final BaseHistoryRepository historyRepository;

  HistoryBloc({@required this.historyRepository})
      : assert(historyRepository != null);

  @override
  HistoryState get initialState => HistoryLoading();

  @override
  Stream<HistoryState> mapEventToState(
    HistoryState currentState,
    HistoryEvent event,
  ) async* {
    if (event is FetchHistory) {
      var list = await historyRepository.readAll(
        sortColumn: History.columnCreatedAt,
        sortAscending: event.order == SortOrder.createdAtAsc,
      );
      yield (list.isNotEmpty
          ? HistoryLoaded(histories: list, order: event.order)
          : HistoryEmpty());
    }
  }

  Future<History> createHistory(History newHistory) {
    var created = historyRepository.create(newHistory);
    var state = currentState;
    dispatch(FetchHistory(
      order: state is HistoryLoaded ? state.order : SortOrder.createdAtDes,
    ));
    return created;
  }

  Future<bool> updateHistory(History history) {
    var updated = historyRepository.update(history);
    var state = currentState;
    dispatch(FetchHistory(
      order: state is HistoryLoaded ? state.order : SortOrder.createdAtDes,
    ));
    return updated;
  }

  Future<bool> deleteHistory(int id) {
    var deleted = historyRepository.delete(id);
    var state = currentState;
    dispatch(FetchHistory(
      order: state is HistoryLoaded ? state.order : SortOrder.createdAtDes,
    ));
    return deleted;
  }
}

abstract class HistoryEvent extends Equatable {
  HistoryEvent([List props = const []]) : super(props);
}

class FetchHistory extends HistoryEvent {
  final SortOrder order;

  FetchHistory({@required this.order})
      : assert(order != null),
        super([order]);
}

abstract class HistoryState extends Equatable {
  HistoryState([List props = const []]) : super(props);
}

class HistoryEmpty extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<History> histories;
  final SortOrder order;

  HistoryLoaded({@required this.histories, @required this.order})
      : assert(histories != null),
        assert(order != null),
        super([histories, order]);
}
