import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class MainDrawerBloc extends Bloc<MainDrawerEvent, MainDrawerState> {
  int initMenu;

  MainDrawerBloc({this.initMenu = 0});

  @override
  MainDrawerState get initialState => MainDrawerState(initMenu);

  @override
  Stream<MainDrawerState> mapEventToState(
    MainDrawerEvent event,
  ) async* {
    if (event is SelectMenu) {
      yield MainDrawerState(event.menu, folderId: event.folderId);
    }
  }
}
