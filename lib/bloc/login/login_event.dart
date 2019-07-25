import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginSubmitted extends LoginEvent {
  final String uid;

  LoginSubmitted(this.uid) : super([uid]);

  @override
  String toString() => "$runtimeType(uid: $uid)";
}
