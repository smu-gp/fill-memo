import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class _SessionState extends Equatable {
  _SessionState([List props = const []]) : super(props);
}

class SessionState extends _SessionState {
  final String userId;

  SessionState(this.userId) : super([userId]);

  @override
  String toString() => "SessionState{userId: $userId}";
}
