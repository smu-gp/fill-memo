import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sp_client/bloc/session/session_event.dart';
import 'package:sp_client/bloc/session/session_state.dart';

import './bloc.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final String initUserId;

  List<String> sessionList;

  String get currentUserId => currentState.userId;

  SessionBloc(this.initUserId);

  @override
  SessionState get initialState => SessionState(initUserId);

  @override
  Stream<SessionState> mapEventToState(
    SessionEvent event,
  ) async* {
    if (event is UpdateSession) {
      if (sessionList.contains(event.userId)) {
      } else {
        sessionList.add(event.userId);
      }
      yield SessionState(event.userId);
    } else if (event is RestoreSession) {
      yield SessionState(initUserId);
    }
  }
}
