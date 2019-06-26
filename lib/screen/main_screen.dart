import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/widget/main_fab.dart';

import '../bloc/blocs.dart';
import '../widget/main_appbar.dart';
import '../widget/main_drawer.dart';
import '../widget/memo_list.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainDrawerBloc _drawerBloc = MainDrawerBloc();
  final ListBloc _listBloc = ListBloc();
  final MemoSortBloc _memoSortBloc = MemoSortBloc();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _listBloc.dispatch(UnSelectable());
        return (_listBloc.currentState is UnSelectableList);
      },
      child: BlocProviderTree(
        blocProviders: [
          BlocProvider<MainDrawerBloc>(
            builder: (context) => _drawerBloc,
            dispose: (context, bloc) => bloc.dispose(),
          ),
          BlocProvider<ListBloc>(
            builder: (context) => _listBloc,
            dispose: (context, bloc) => bloc.dispose(),
          ),
          BlocProvider<MemoSortBloc>(
            builder: (context) => _memoSortBloc,
            dispose: (context, bloc) => bloc.dispose(),
          ),
        ],
        child: Scaffold(
          appBar: MainAppBar(),
          drawer: MainDrawer(),
          body: BlocBuilder<MainDrawerEvent, MainDrawerState>(
            bloc: _drawerBloc,
            builder: (context, state) {
              return MemoList(folderId: state.folderId);
            },
          ),
          floatingActionButton: MainFloatingActionButton(),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }
}
