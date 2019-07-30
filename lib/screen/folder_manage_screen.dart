import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/edit_text_dialog.dart';
import 'package:sp_client/widget/loading_progress.dart';

class FolderManageScreen extends StatefulWidget {
  @override
  _FolderManageScreenState createState() => _FolderManageScreenState();
}

class _FolderManageScreenState extends State<FolderManageScreen> {
  final ListBloc _listBloc = ListBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FolderBloc, FolderState>(
      listener: (context, folderState) {
        if (folderState is FoldersLoaded && folderState.folders.isEmpty) {
          Navigator.pop(context);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          _listBloc.dispatch(UnSelectable());
          return (_listBloc.currentState is UnSelectableList);
        },
        child: BlocProvider<ListBloc>(
          builder: (context) => _listBloc,
          child: Scaffold(
            appBar: _FolderManageAppBar(),
            body: _FolderList(),
          ),
        ),
      ),
    );
  }
}

class _FolderManageAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;

  @override
  final Size preferredSize;

  _FolderManageAppBar({
    Key key,
    this.bottom,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var listBloc = BlocProvider.of<ListBloc>(context);
    return BlocBuilder<ListBloc, ListState>(
      bloc: listBloc,
      builder: (context, state) {
        var isSelectable = (state is SelectableList);
        var selectItemsCount;
        if (isSelectable) {
          selectItemsCount = (state as SelectableList).selectedItemCount;
        }
        return AppBar(
          leading: isSelectable
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => listBloc.dispatch(UnSelectable()),
                )
              : null,
          title: Text(isSelectable
              ? selectItemsCount.toString()
              : AppLocalizations.of(context).actionManageFolder),
          backgroundColor: isSelectable ? Theme.of(context).accentColor : null,
          actions: <Widget>[
            if (isSelectable)
              ..._buildSelectableActions(context)
            else
              ..._buildUnSelectableActions(context)
          ],
          elevation: 0,
        );
      },
    );
  }

  List<Widget> _buildUnSelectableActions(BuildContext context) {
    var listBloc = BlocProvider.of<ListBloc>(context);
    return [
      IconButton(
        icon: Icon(OMIcons.delete),
        tooltip: AppLocalizations.of(context).actionEdit,
        onPressed: () => listBloc.dispatch(Selectable()),
      )
    ];
  }

  List<Widget> _buildSelectableActions(BuildContext context) {
    var listBloc = BlocProvider.of<ListBloc>(context);
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    var memoBloc = BlocProvider.of<MemoBloc>(context);

    var listState = (listBloc.currentState as SelectableList);
    var selectedItemCount = listState.selectedItemCount;
    var selectedItems = listState.selectedItems;
    var memoItems = (memoBloc.currentState as MemosLoaded).memos;

    return [
      IconButton(
        icon: Icon(OMIcons.delete),
        onPressed: selectedItemCount > 0
            ? () {
                selectedItems.forEach((item) {
                  var folder = item as Folder;
                  var folderMemos =
                      memoItems.where((memo) => memo.folderId == folder.id);
                  folderMemos.forEach((memo) {
                    var updatedMemo = memo..folderId = Folder.defaultId;
                    memoBloc.dispatch(UpdateMemo(updatedMemo));
                  });
                  folderBloc.dispatch(DeleteFolder(folder));
                });
                listBloc.dispatch(UnSelectable());
              }
            : null,
      ),
    ];
  }
}

class _FolderList extends StatefulWidget {
  @override
  _FolderListState createState() => _FolderListState();
}

class _FolderListState extends State<_FolderList> {
  @override
  Widget build(BuildContext context) {
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    return BlocBuilder<FolderBloc, FolderState>(
      bloc: folderBloc,
      builder: (context, folderState) {
        if (folderState is FoldersLoaded) {
          var folders = folderState.folders;
          var listBloc = BlocProvider.of<ListBloc>(context);
          return BlocBuilder<ListBloc, ListState>(
            bloc: listBloc,
            builder: (context, listState) {
              var isSelectable = (listState is SelectableList);
              List<dynamic> selectItems;
              if (isSelectable) {
                selectItems = (listState as SelectableList).selectedItems;
              }
              return ListView.builder(
                itemBuilder: (context, index) => _FolderItem(
                  folders[index],
                  selected:
                      (isSelectable && selectItems.contains(folders[index])),
                  selectable: isSelectable,
                  onTap: () {
                    if (isSelectable) {
                      var isSelected = selectItems.contains(folders[index]);
                      if (isSelected) {
                        listBloc.dispatch(UnSelectItem(folders[index]));
                      } else {
                        listBloc.dispatch(SelectItem(folders[index]));
                      }
                    }
                  },
                  onLongPress: () {
                    listBloc.dispatch(SelectItem(folders[index]));
                  },
                  onCheckboxChanged: (value) {
                    if (value) {
                      listBloc.dispatch(SelectItem(folders[index]));
                    } else {
                      listBloc.dispatch(UnSelectItem(folders[index]));
                    }
                  },
                  onEditButtonPress: () async {
                    var folder = folders[index];
                    var newName = await showDialog(
                      context: context,
                      builder: (context) => EditTextDialog(
                        title: AppLocalizations.of(context).actionRenameFolder,
                        value: folder.name,
                        validation: (value) => value.isNotEmpty,
                        validationMessage:
                            AppLocalizations.of(context).errorEmptyName,
                      ),
                    );
                    if (newName != null) {
                      var updatedFolder = folder..name = newName;
                      folderBloc.dispatch(UpdateFolder(updatedFolder));
                    }
                  },
                ),
                itemCount: folders.length,
              );
            },
          );
        } else {
          return LoadingProgress();
        }
      },
    );
  }
}

class _FolderItem extends StatefulWidget {
  final Folder folder;
  final bool selectable;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onCheckboxChanged;
  final VoidCallback onEditButtonPress;

  _FolderItem(
    this.folder, {
    Key key,
    this.selectable = false,
    this.selected = false,
    @required this.onTap,
    @required this.onLongPress,
    @required this.onCheckboxChanged,
    this.onEditButtonPress,
  }) : super(key: key);

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<_FolderItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        height: 56.0,
        padding:
            EdgeInsets.symmetric(horizontal: widget.selectable ? 4.0 : 16.0),
        child: Row(
          children: <Widget>[
            if (widget.selectable)
              Checkbox(
                value: widget.selected,
                onChanged: widget.onCheckboxChanged,
              )
            else
              Icon(OMIcons.folder),
            SizedBox(width: widget.selectable ? 20.0 : 32.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.folder.name,
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontSize: 16.0,
                        ),
                  )
                ],
              ),
            ),
            if (!widget.selectable)
              IconButton(
                icon: Icon(OMIcons.edit),
                onPressed: widget.onEditButtonPress,
              ),
          ],
        ),
      ),
    );
  }
}
