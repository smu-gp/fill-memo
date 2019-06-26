import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SessionEvent extends Equatable {
  SessionEvent([List props = const []]) : super(props);
}

class UpdateSession extends SessionEvent {
  final String userId;

  UpdateSession(this.userId) : super([userId]);

  @override
  String toString() => 'UpdateSession{userId: $userId}';
}

class RestoreSession extends SessionEvent {
  @override
  String toString() => 'RestoreSession';
}
