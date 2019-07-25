import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/widget/main_appbar.dart';
import 'package:sp_client/widget/main_drawer.dart';
import 'package:sp_client/widget/main_fab.dart';
import 'package:sp_client/widget/memo_list.dart';

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MainDrawerBloc>(
            builder: (context) => _drawerBloc,
          ),
          BlocProvider<ListBloc>(
            builder: (context) => _listBloc,
          ),
          BlocProvider<MemoSortBloc>(
            builder: (context) => _memoSortBloc,
          ),
        ],
        child: Scaffold(
          appBar: MainAppBar(),
          drawer: MainDrawer(),
          body: BlocBuilder<MainDrawerBloc, MainDrawerState>(
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
