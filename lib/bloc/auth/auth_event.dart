import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthEvent {
  final String initUserId;

  AppStarted(this.initUserId) : super([initUserId]);

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

class ProfileUpdated extends AuthEvent {
  final String name;
  final String email;

  ProfileUpdated({this.name, this.email}) : super([name, email]);

  @override
  String toString() => "$runtimeType(name: $name, email: $email)";
}

class ChangedUser extends AuthEvent {
  final String changeUserId;

  ChangedUser(this.changeUserId) : super([changeUserId]);

  @override
  String toString() => "$runtimeType(changeUserId: $changeUserId)";
}
