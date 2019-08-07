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
  final String uid;
  final String displayName;
  final String email;

  Authenticated({this.uid, this.displayName, this.email})
      : super([uid, displayName, email]);

  Authenticated update({
    String displayName,
    String email,
  }) {
    return copyWith(
      displayName: displayName,
      email: email,
    );
  }

  Authenticated copyWith({
    String uid,
    String displayName,
    String email,
  }) {
    return Authenticated(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
    );
  }

  @override
  String toString() =>
      "$runtimeType(uid: $uid, displayName: $displayName, email: $email)";
}

class Unauthenticated extends AuthState {
  @override
  String toString() => "$runtimeType";
}
