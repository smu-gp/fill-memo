import 'package:meta/meta.dart';

@immutable
class LoginState {
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  LoginState({
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory LoginState.empty() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  LoginState copyWith({
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return "$runtimeType(isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure)";
  }
}
