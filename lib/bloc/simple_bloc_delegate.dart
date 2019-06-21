import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(
      "onTransition(bloc: ${bloc.toString()}, transition: ${transition.toString()})",
    );
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint(
      "onEvent(bloc: ${bloc.toString()}, event: ${event.toString()})",
    );
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    debugPrint(
      "onError(bloc: ${bloc.toString()}, error: ${error.toString()})",
    );
    debugPrint(stacktrace.toString());
  }
}
