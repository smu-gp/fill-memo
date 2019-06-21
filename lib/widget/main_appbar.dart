import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../bloc/blocs.dart';
import '../model/models.dart';
import '../util/utils.dart';
import '../widget/sort_dialog.dart';
import 'edit_text_dialog.dart';

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
    var historyListBloc = BlocProvider.of<HistoryListBloc>(context);

    return BlocBuilder<MainDrawerEvent, MainDrawerState>(
      bloc: drawerBloc,
      builder: (context, drawerState) {
        return BlocBuilder<HistoryListEvent, HistoryListState>(
          bloc: historyListBloc,
          builder: (context, historyListState) {
            return AppBar(
              bottom: bottom,
              leading: (historyListState is UnSelectableList
                  ? null
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        historyListBloc.dispatch(UnSelectable());
                      },
                    )),
              title: Text(
                (historyListState is UnSelectableList
                    ? (drawerState.selectedMenu == 0
                        ? AppLocalizations.of(context).actionDate
                        : AppLocalizations.of(context).actionFolder)
                    : (historyListState as SelectableList)
                        .selectedItemCount
                        .toString()),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: (historyListState is UnSelectableList
                  ? null
                  : Theme.of(context).accentColor),
              elevation: Util.isTablet(context) ? 4.0 : 0.0,
              actions: (historyListState is UnSelectableList
                  ? (drawerState.selectedMenu == 0
                      ? _buildDateActions(context)
                      : _buildFolderActions(context))
                  : _buildSelectableActions(context, historyListBloc)),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildDateActions(BuildContext context) {
    var historyListBloc = BlocProvider.of<HistoryListBloc>(context);
    return [
      IconButton(
        icon: Icon(Icons.sort),
        tooltip: AppLocalizations.of(context).actionSort,
        onPressed: () => showDialog(
          context: context,
          builder: (context) => SortDialog(),
        ),
      ),
      IconButton(
        icon: Icon(OMIcons.edit),
        tooltip: AppLocalizations.of(context).actionEdit,
        onPressed: () {
          historyListBloc.dispatch(Selectable());
        },
      ),
    ];
  }

  List<Widget> _buildFolderActions(BuildContext context) {
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    return <Widget>[
      IconButton(
        icon: Icon(OMIcons.createNewFolder),
        tooltip: AppLocalizations.of(context).actionAddFolder,
        onPressed: () async {
          var folderName = await showDialog(
            context: context,
            builder: (context) => EditTextDialog(
              title: AppLocalizations.of(context).actionAddFolder,
              validation: (value) => value.isNotEmpty,
              validationMessage: AppLocalizations.of(context).errorEmptyName,
            ),
          );
          if (folderName != null) {
            folderBloc.dispatch(AddFolder(Folder(name: folderName)));
          }
        },
      ),
    ];
  }

  List<Widget> _buildSelectableActions(
    BuildContext context,
    HistoryListBloc historyListBloc,
  ) {
    var historyBloc = BlocProvider.of<HistoryBloc>(context);
    var resultBloc = BlocProvider.of<ResultBloc>(context);
    return [
      IconButton(
        icon: Icon(OMIcons.delete),
        tooltip: AppLocalizations.of(context).actionDelete,
        onPressed: () {
          var state = historyListBloc.currentState as SelectableList;
          var items = state.selectedItems;
          items.forEach((item) {
            // LocalImageRepository.deleteImage(item.sourceImage);
            historyBloc.dispatch(DeleteHistory(item.id));
            resultBloc.deleteResults(item.id);
          });
          historyListBloc.dispatch(UnSelectable());
        },
      ),
    ];
  }
}
