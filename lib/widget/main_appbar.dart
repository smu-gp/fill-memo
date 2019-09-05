import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/sort_dialog.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;

  @override
  final Size preferredSize;

  MainAppBar({
    Key key,
    this.bottom,
  })  : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var drawerBloc = BlocProvider.of<MainDrawerBloc>(context);
    var listBloc = BlocProvider.of<ListBloc>(context);

    return BlocListener<FolderBloc, FolderState>(
      listener: (context, folderState) {
        if (folderState is FoldersLoaded && folderState.folders.isEmpty) {
          drawerBloc.dispatch(SelectMenu(0));
        }
      },
      child: BlocBuilder<FolderBloc, FolderState>(
        builder: (context, folderState) {
          return BlocBuilder<MainDrawerBloc, MainDrawerState>(
            builder: (context, drawerState) {
              return BlocBuilder<ListBloc, ListState>(
                builder: (context, memoListState) {
                  var title;
                  if (memoListState is UnSelectableList) {
                    if (drawerState.selectedMenu == 0) {
                      title = AppLocalizations.of(context).actionNotes;
                    } else {
                      if (drawerState.folderId != null) {
                        if (drawerState.folderId == Folder.defaultId) {
                          title = AppLocalizations.of(context).folderDefault;
                        } else if (folderState is FoldersLoaded) {
                          var folders = folderState.folders;
                          var findFolder = folders.firstWhere(
                              (folder) => folder.id == drawerState.folderId);
                          title = findFolder?.name ??
                              AppLocalizations.of(context).actionFolder;
                        }
                      } else {
                        title = AppLocalizations.of(context).actionFolder;
                      }
                    }
                  } else {
                    title = (memoListState as SelectableList)
                        .selectedItemCount
                        .toString();
                  }

                  return AppBar(
                    bottom: bottom,
                    leading: (memoListState is UnSelectableList
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                            ),
                            onPressed: () {
                              listBloc.dispatch(UnSelectable());
                            },
                          )),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: (memoListState is UnSelectableList
                        ? null
                        : Theme.of(context).accentColor),
                    elevation: memoListState is SelectableList ? 4.0 : 0.0,
                    actions: (memoListState is UnSelectableList
                        ? _buildNotesActions(context)
                        : _buildSelectableActions(context)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildNotesActions(BuildContext context) {
    var listBloc = BlocProvider.of<ListBloc>(context);
    var memoSort = Provider.of<MemoSort>(context);
    return [
      PopupMenuButton<NotesMenuItem>(
        onSelected: (NotesMenuItem selected) {
          if (selected == NotesMenuItem.actionEdit) {
            listBloc.dispatch(Selectable());
          } else if (selected == NotesMenuItem.actionSort) {
            showDialog(
              context: context,
              builder: (context) {
                return ChangeNotifierProvider<MemoSort>.value(
                  value: memoSort,
                  child: SortDialog(),
                );
              },
            );
          }
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<NotesMenuItem>>[
            PopupMenuItem<NotesMenuItem>(
              value: NotesMenuItem.actionEdit,
              child: Text(AppLocalizations.of(context).actionEdit),
            ),
            PopupMenuItem<NotesMenuItem>(
              value: NotesMenuItem.actionSort,
              child: Text(AppLocalizations.of(context).actionSort),
            ),
          ];
        },
      )
    ];
  }

  List<Widget> _buildSelectableActions(BuildContext context) {
    final availableMergeType = [typeRichText];

    var memoBloc = BlocProvider.of<MemoBloc>(context);
    var drawerBloc = BlocProvider.of<MainDrawerBloc>(context);
    var listBloc = BlocProvider.of<ListBloc>(context);

    var drawerState = drawerBloc.currentState;
    var listState = listBloc.currentState as SelectableList;
    var selectedItems = List.castFrom<dynamic, Memo>(listState.selectedItems);

    var memosType = _checkMemosType(selectedItems);
    var canMerge =
        selectedItems.length > 1 && availableMergeType.contains(memosType);

    return [
      if (canMerge)
        IconButton(
          icon: Icon(Icons.merge_type),
          onPressed: () {
            memoBloc.dispatch(MergeMemo(memosType, selectedItems));
            listBloc.dispatch(UnSelectable());
          },
        ),
      IconButton(
        icon: Icon(OMIcons.delete),
        tooltip: AppLocalizations.of(context).actionDelete,
        onPressed: () {
          selectedItems.forEach((item) {
            memoBloc.dispatch(DeleteMemo(item));
          });
          listBloc.dispatch(UnSelectable());
        },
      ),
      if (drawerState.folderId != null)
        PopupMenuButton<EditNotesMenuItem>(
          onSelected: (EditNotesMenuItem selected) async {
            if (selected == EditNotesMenuItem.actionMoveFolder) {
              var folderId = await _selectFolder(context);
              if (folderId != null) {
                selectedItems.forEach((item) {
                  var updatedMemo = (item as Memo)..folderId = folderId;
                  memoBloc.dispatch(UpdateMemo(updatedMemo));
                });
              }
              listBloc.dispatch(UnSelectable());
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<EditNotesMenuItem>>[
              PopupMenuItem<EditNotesMenuItem>(
                value: EditNotesMenuItem.actionMoveFolder,
                child: Text(AppLocalizations.of(context).actionMoveFolder),
              ),
            ];
          },
        )
    ];
  }

  String _checkMemosType(List<Memo> memos) {
    var type = memos.first.type;
    for (var index = 1; index < memos.length; index++) {
      var memo = memos[index];
      if (memo.type != type) {
        return null;
      }
    }
    return type;
  }

  Future<String> _selectFolder(BuildContext context) async {
    var folder;
    if (Util.isLarge(context)) {
      folder = await showDialog(
        context: context,
        builder: (context) => Routes().selectFolderDialog(context),
      );
    } else {
      folder = await Navigator.push(context, Routes().selectFolder());
    }
    return folder?.id ?? null;
  }
}
