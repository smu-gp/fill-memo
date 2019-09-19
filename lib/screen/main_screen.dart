import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/memo_list_type.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/routes.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/main_appbar.dart';
import 'package:fill_memo/widget/main_drawer.dart';
import 'package:fill_memo/widget/main_fab.dart';
import 'package:fill_memo/widget/memo_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainDrawerBloc _drawerBloc = MainDrawerBloc();
  final ListBloc _listBloc = ListBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _navigateNewMemo(onStartup: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Scaffold(
      appBar: MainAppBar(),
      drawer: !Util.isLarge(context) ? MainDrawer() : null,
      body: Consumer<MemoListType>(builder: (context, listType, child) {
        return BlocBuilder<MainDrawerBloc, MainDrawerState>(
          bloc: _drawerBloc,
          builder: (context, state) {
            return Center(
              child: Container(
                width: Dimensions.listWidth(context),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.keylineSmall,
                ),
                child: MemoList(
                  folderId: state.folderId,
                  listType: listType.value,
                  onTap: _onMemoTapped,
                  onLongPress: _onMemoLongPressed,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: MainFloatingActionButton(
        onPressed: _navigateNewMemo,
      ),
      resizeToAvoidBottomPadding: false,
    );

    if (Util.isLarge(context)) {
      child = Row(
        children: <Widget>[
          MainDrawer(),
          Expanded(child: child),
        ],
      );
    }

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
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<MemoSort>(
              builder: (_) => MemoSort(),
            ),
            ChangeNotifierProvider<MemoListType>(
              builder: (_) => MemoListType(),
            ),
          ],
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _drawerBloc.dispose();
    _listBloc.dispose();
    super.dispose();
  }

  void _onMemoTapped(Memo memo, bool selectable, bool selected) {
    if (selectable) {
      _listBloc.dispatch(selected ? UnSelectItem(memo) : SelectItem(memo));
    } else {
      Navigator.push(context, Routes().memo(memo));
    }
  }

  void _onMemoLongPressed(Memo memo, bool selectable) {
    _listBloc.dispatch(SelectItem(memo));
  }

  void _navigateNewMemo({bool onStartup = false}) {
    var preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);

    var newNoteOnStartup =
        preferenceRepository.getBool(AppPreferences.keyNewNoteOnStartup) ??
            false;

    if (onStartup && !newNoteOnStartup) {
      return;
    }

    var quickFolderClassification = preferenceRepository
            .getBool(AppPreferences.keyQuickFolderClassification) ??
        true;

    var defaultMemoType =
        preferenceRepository.getString(AppPreferences.keyDefaultMemoType) ??
            typeRichText;

    var destination;
    if (quickFolderClassification) {
      destination = Routes().memoTitle(defaultMemoType);
    } else {
      destination = Routes().memo(Memo.empty(defaultMemoType));
    }
    Navigator.push(context, destination);
  }
}
