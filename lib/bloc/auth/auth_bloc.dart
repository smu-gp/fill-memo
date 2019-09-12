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
      yield* _mapAppStartedToState(event);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedToState(event);
    } else if (event is ChangedUser) {
      yield* _mapChangedUserToState(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState(AppStarted event) async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        if (user.uid == event.initUserId) {
          yield Authenticated(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
          );
        } else {
          dispatch(LoggedOut());
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoggedInToState() async* {
    final user = await _userRepository.getUser();
    yield Authenticated(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }

  Stream<AuthState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }

  Stream<AuthState> _mapProfileUpdatedToState(ProfileUpdated event) async* {
    final user = await _userRepository.updateProfile(
      displayName: event.name,
      email: event.email,
    );
    yield (currentState as Authenticated).update(
      displayName: user.displayName,
      email: user.email,
    );
  }

  Stream<AuthState> _mapChangedUserToState(ChangedUser event) async* {
    if (await _userRepository.isSignedIn()) {
      await _userRepository.signOut();
      await _userRepository.signIn(event.changeUserId);
    } else {
      await _userRepository.signIn(event.changeUserId);
    }
    dispatch(LoggedIn());
  }
}
