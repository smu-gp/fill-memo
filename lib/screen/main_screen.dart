import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/screen/area_select_screen.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/add_folder_dialog.dart';
import 'package:sp_client/widget/folder_grid.dart';
import 'package:sp_client/widget/history_list.dart';
import 'package:sp_client/widget/sort_dialog.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  HistoryBloc _historyBloc;
  FolderBloc _folderBloc;
  ResultBloc _resultBloc;

  int _navigationIndex = 0;

  @override
  void initState() {
    _historyBloc = BlocProvider.of<HistoryBloc>(context)
      ..dispatch(FetchHistory(
        order: SortOrder.createdAtDes,
      ));
    _folderBloc = BlocProvider.of<FolderBloc>(context)
      ..dispatch(
        FetchFolder(),
      );
    _resultBloc = BlocProvider.of<ResultBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _historyListBloc.dispatch(UnselectableEvent());
    return BlocBuilder<HistoryListEvent, HistoryListState>(
      bloc: _historyListBloc,
      builder: (BuildContext context, HistoryListState state) {
        return WillPopScope(
          onWillPop: () async {
            _historyListBloc.dispatch(UnselectableEvent());
            return (state is UnselectableList);
          },
          child: Scaffold(
            appBar: _buildAppBar(state),
            body: [
              BlocProvider<HistoryListBloc>(
                bloc: _historyListBloc,
                child: HistoryList(),
              ),
              FolderGrid(),
            ].elementAt(_navigationIndex),
            bottomNavigationBar: _buildBottomNavigation(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: _buildFloatingActionButton(state),
            resizeToAvoidBottomPadding: false,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _historyListBloc.dispose();
    super.dispose();
  }

  Widget _buildAppBar(HistoryListState state) {
    return AppBar(
      leading: (state is UnselectableList
          ? null
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _historyListBloc.dispatch(UnselectableEvent());
              },
            )),
      title: Text(
        (state is UnselectableList
            ? AppLocalizations.of(context).titleHistory
            : (state as SelectableList).selectedItemCount.toString()),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:
          (state is UnselectableList ? null : Theme.of(context).accentColor),
      elevation: 0.0,
      actions: (state is UnselectableList
          ? (_navigationIndex == 0
              ? _buildDateActions()
              : _buildFolderActions())
          : _buildSelectableActions()),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(OMIcons.dateRange),
            color: Colors.white70,
            disabledColor: Theme.of(context).accentColor,
            onPressed: _navigationIndex == 0
                ? null
                : () => setState(() => _navigationIndex = 0),
          ),
          IconButton(
            icon: Icon(OMIcons.folder),
            color: Colors.white70,
            disabledColor: Theme.of(context).accentColor,
            onPressed: _navigationIndex == 1
                ? null
                : () => setState(() => _navigationIndex = 1),
          )
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(HistoryListState state) {
    return AnimatedOpacity(
      opacity: _navigationIndex == 0 && state is UnselectableList ? 1.0 : 0.0,
      duration: Duration(milliseconds: 200),
      child: FloatingActionButton(
        tooltip: AppLocalizations.of(context).actionAddImage,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: _buildAddImageSheet,
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildDateActions() {
    return [
      IconButton(
        icon: Icon(Icons.sort),
        tooltip: AppLocalizations.of(context).actionSort,
        onPressed: () => showDialog(
              context: context,
              builder: (context) => SortDialog(),
            ),
      ),
      PopupMenuButton<MainMenuItem>(
        itemBuilder: (context) => [
              PopupMenuItem<MainMenuItem>(
                child: Text(AppLocalizations.of(context).actionEdit),
                height: 56.0,
                value: MainMenuItem.actionEdit,
              ),
              PopupMenuItem<MainMenuItem>(
                child: Text(AppLocalizations.of(context).actionSettings),
                height: 56.0,
                value: MainMenuItem.actionSettings,
              ),
            ],
        onSelected: (selected) {
          switch (selected) {
            case MainMenuItem.actionEdit:
              _historyListBloc.dispatch(SelectableEvent());
              break;
            case MainMenuItem.actionSettings:
              break;
            default:
              break;
          }
        },
      ),
    ];
  }

  List<Widget> _buildFolderActions() {
    return [
      IconButton(
        icon: Icon(OMIcons.createNewFolder),
        tooltip: AppLocalizations.of(context).actionAddFolder,
        onPressed: () => showDialog(
              context: context,
              builder: (context) => AddFolderDialog(),
            ),
      ),
      PopupMenuButton<MainMenuItem>(
        itemBuilder: (context) => [
              PopupMenuItem<MainMenuItem>(
                child: Text(AppLocalizations.of(context).actionSettings),
                height: 56.0,
                value: MainMenuItem.actionSettings,
              ),
            ],
        onSelected: (selected) {
          switch (selected) {
            case MainMenuItem.actionSettings:
              break;
            default:
              break;
          }
        },
      ),
    ];
  }

  List<Widget> _buildSelectableActions() {
    return [
      IconButton(
        icon: Icon(OMIcons.delete),
        tooltip: AppLocalizations.of(context).actionDelete,
        onPressed: () {
          var state = _historyListBloc.currentState as SelectableList;
          var items = state.selectedItems;
          items.forEach((item) {
            _historyBloc.deleteHistory(item.id);
            _resultBloc.deleteResultByHistoryId(item.id);
          });
          _historyListBloc.dispatch(UnselectableEvent());
        },
      ),
    ];
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
            builder: (context) => AreaSelectScreen(
                  selectImage: image,
                ),
          ));
    }
  }
}
