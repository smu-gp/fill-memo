import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/memo_screen.dart';
import 'package:sp_client/screen/memo_title_screen.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/utils.dart';
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
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final MainDrawerBloc _drawerBloc = MainDrawerBloc();
  final ListBloc _listBloc = ListBloc();
  final MemoSortBloc _memoSortBloc = MemoSortBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _navigateNewMemo(onStartup: true));
  }

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
          key: _scaffoldKey,
          appBar: MainAppBar(),
          drawer: MainDrawer(),
          body: BlocBuilder<MainDrawerBloc, MainDrawerState>(
            bloc: _drawerBloc,
            builder: (context, state) {
              return MemoList(folderId: state.folderId);
            },
          ),
          floatingActionButton:
              MainFloatingActionButton(onPressed: _navigateNewMemo),
          resizeToAvoidBottomPadding: false,
        ),
      ),
    );
  }

  void _navigateNewMemo({bool onStartup = false}) {
    var preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    var newNoteOnStartup =
        preferenceBloc.getPreference(AppPreferences.keyNewNoteOnStartup).value;

    if (onStartup && !newNoteOnStartup) {
      return;
    }

    var quickFolderClassification = preferenceBloc
        .getPreference<bool>(AppPreferences.keyQuickFolderClassification)
        .value;

    var defaultMemoType = preferenceBloc
        .getPreference<String>(AppPreferences.keyDefaultMemoType)
        .value;

    if (defaultMemoType != typeRichText) {
      _scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Not supported type : $defaultMemoType"),
        ));
      return;
    }

    var destination;
    if (quickFolderClassification) {
      destination = MemoTitleScreen(defaultMemoType);
    } else {
      destination = MemoScreen(Memo.empty(defaultMemoType));
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
