import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthEvent {
  @override
  String toString() => "$runtimeType";
}

class LoggedIn extends AuthEvent {
  @override
  String toString() => "$runtimeType";
}

class LoggedOut extends AuthEvent {
  @override
  String toString() => "$runtimeType";
}
