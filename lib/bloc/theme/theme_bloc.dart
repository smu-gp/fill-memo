import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeBloc extends Bloc<ThemeData, ThemeData> {
  final ThemeData initTheme;

  ThemeBloc(this.initTheme);

  @override
  ThemeData get initialState => initTheme;

  @override
  Stream<ThemeData> mapEventToState(ThemeData event) async* {
    yield event;
  }
}
