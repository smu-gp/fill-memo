import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/widget/main_appbar.dart';

import '../bloc/blocs.dart';
import '../bloc/main_drawer/bloc.dart';
import '../model/models.dart';
import '../model/sort_order.dart';
import '../screen/add_image_screen.dart';
import '../util/localization.dart';
import '../util/utils.dart';
import '../widget/folder_grid.dart';
import '../widget/history_list.dart';
import '../widget/main_drawer.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  final MainDrawerBloc _drawerBloc = MainDrawerBloc();

  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  FolderBloc _folderBloc;

  int _navigationIndex = 0;

  @override
  void initState() {
    _historyBloc = BlocProvider.of<HistoryBloc>(context)
      ..dispatch(LoadHistory(SortOrder.createdAtDes));
    _resultBloc = BlocProvider.of<ResultBloc>(context);
    _folderBloc = BlocProvider.of<FolderBloc>(context)..dispatch(LoadFolder());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryListEvent, HistoryListState>(
      bloc: _historyListBloc,
      builder: (BuildContext context, HistoryListState state) {
        return WillPopScope(
          onWillPop: () async {
            _historyListBloc.dispatch(UnSelectable());
            return (state is UnSelectableList);
          },
          child: BlocProviderTree(
            blocProviders: [
              BlocProvider<HistoryListBloc>(
                builder: (context) => _historyListBloc,
                dispose: (context, bloc) => bloc.dispose(),
              ),
              BlocProvider<MainDrawerBloc>(
                builder: (context) => _drawerBloc,
                dispose: (context, bloc) => bloc.dispose(),
              ),
            ],
            child: Scaffold(
              appBar: MainAppBar(),
              drawer: MainDrawer(),
              body: BlocBuilder<MainDrawerEvent, MainDrawerState>(
                bloc: _drawerBloc,
                builder: (context, state) => [
                  HistoryList(),
                  FolderGrid(),
                ].elementAt(state.selectedMenu),
              ),
              floatingActionButton: _buildFloatingActionButton(state),
              resizeToAvoidBottomPadding: false,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(HistoryListState state) {
    return AnimatedOpacity(
      opacity: _navigationIndex == 0 && state is UnSelectableList ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        tooltip: AppLocalizations.of(context).actionAddImage,
        onPressed: _navigationIndex == 0
            ? () {
                showModalBottomSheet(
                  context: context,
                  builder: _buildAddImageSheet,
                );
              }
            : null,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddImageSheet(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(
              OMIcons.image,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).imageFromGallery),
            onTap: () {
              _pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              OMIcons.photoCamera,
              color: Theme.of(context).accentColor,
            ),
            title: Text(AppLocalizations.of(context).imageFromCamera),
            onTap: () {
              _pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _pickImage(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    if (image != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddImageScreen(
              selectImage: image,
            ),
          ));
    }
  }
}
