import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class Uninitialized extends AuthState {
  @override
  String toString() => "$runtimeType";
}

class Authenticated extends AuthState {
  final String displayName;
  final String email;

  Authenticated(this.displayName, this.email) : super([displayName, email]);

  @override
  String toString() => "$runtimeType(displayName: $displayName, email: $email)";
}

class Unauthenticated extends AuthState {
  @override
  String toString() => "$runtimeType";
}
