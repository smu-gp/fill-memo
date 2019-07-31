import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/repository/repositories.dart';

import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;

  AuthBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield Authenticated(user.uid, user.displayName, user.email);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final user = await _userRepository.getUser();
    yield Authenticated(user.uid, user.displayName, user.email);
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
