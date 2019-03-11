import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/delete_folder_dialog.dart';
import 'package:sp_client/widget/history_list.dart';
import 'package:sp_client/widget/rename_folder_dialog.dart';
import 'package:sp_client/widget/select_folder_dialog.dart';
import 'package:sp_client/widget/sort_dialog.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder;

  const FolderDetailScreen({
    Key key,
    @required this.folder,
  }) : super(key: key);

  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  final HistoryListBloc _historyListBloc = HistoryListBloc();
  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;

  @override
  void initState() {
    _historyBloc = BlocProvider.of<HistoryBloc>(context);
    _resultBloc = BlocProvider.of<ResultBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            body: BlocProvider<HistoryListBloc>(
              bloc: _historyListBloc,
              child: HistoryList(
                folderId: widget.folder.id,
              ),
            ),
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

  AppBar _buildAppBar(HistoryListState state) {
    return AppBar(
      leading: (state is UnselectableList
          ? null
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _historyListBloc.dispatch(UnselectableEvent());
              },
            )),
      title: Text((state is UnselectableList
          ? widget.folder.name
          : (state as SelectableList).selectedItemCount.toString())),
      backgroundColor:
          (state is UnselectableList ? null : Theme.of(context).accentColor),
      elevation: 0.0,
      actions: (state is UnselectableList
          ? _buildActions()
          : _buildSelectableActions()),
    );
  }

  List<Widget> _buildActions() {
    return [
      IconButton(
        icon: Icon(Icons.sort),
        tooltip: AppLocalizations.of(context).actionSort,
        onPressed: () => showDialog(
              context: context,
              builder: (context) => SortDialog(),
            ),
      ),
      PopupMenuButton<FolderDetailMenuItem>(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem<FolderDetailMenuItem>(
                child: Text(AppLocalizations.of(context).actionEdit),
                height: 56.0,
                value: FolderDetailMenuItem.actionEdit,
              ),
              PopupMenuItem<FolderDetailMenuItem>(
                child: Text(AppLocalizations.of(context).actionRenameFolder),
                height: 56.0,
                value: FolderDetailMenuItem.actionRenameFolder,
                enabled: widget.folder.id != 0,
              ),
              PopupMenuItem<FolderDetailMenuItem>(
                child: Text(AppLocalizations.of(context).actionRemoveFolder),
                height: 56.0,
                value: FolderDetailMenuItem.actionRemoveFolder,
                enabled: widget.folder.id != 0,
              )
            ],
        onSelected: (selected) async {
          switch (selected) {
            case FolderDetailMenuItem.actionEdit:
              _historyListBloc.dispatch(SelectableEvent());
              break;
            case FolderDetailMenuItem.actionRenameFolder:
              showDialog(
                context: context,
                builder: (context) => RenameFolderDialog(folder: widget.folder),
              );
              break;
            case FolderDetailMenuItem.actionRemoveFolder:
              bool isDeleteSelected = await showDialog(
                  context: context,
                  builder: (context) => DeleteFolderDialog(
                        folder: widget.folder,
                      ));
              if (isDeleteSelected) {
                Navigator.pop(context);
              }
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
      PopupMenuButton<FolderDetailEditMenuItem>(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem<FolderDetailEditMenuItem>(
                child: Text(AppLocalizations.of(context).actionMoveFolder),
                height: 56.0,
                value: FolderDetailEditMenuItem.actionMoveFolder,
              )
            ],
        onSelected: (selected) async {
          switch (selected) {
            case FolderDetailEditMenuItem.actionMoveFolder:
              var selectFolder = await Navigator.push<Folder>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectFolderDialog(),
                    fullscreenDialog: true,
                  ));
              if (selectFolder != null) {
                _moveHistoriesToFolder(selectFolder);
              }
              _historyListBloc.dispatch(UnselectableEvent());
              break;
          }
        },
      )
    ];
  }

  void _moveHistoriesToFolder(Folder folder) {
    var items = (_historyListBloc.currentState as SelectableList).selectedItems;
    if (items.isNotEmpty) {
      items.forEach((history) {
        var updateHistory = history..folderId = folder.id;
        _historyBloc.updateHistory(updateHistory);
      });
    }
  }
}
