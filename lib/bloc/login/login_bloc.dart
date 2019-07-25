import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/repository/repositories.dart';

import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event.uid);
    }
  }

  Stream<LoginState> _mapLoginSubmittedToState(String uid) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signIn(uid);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
