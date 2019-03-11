import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';

class DeleteFolderDialog extends StatelessWidget {
  final Folder folder;

  const DeleteFolderDialog({
    Key key,
    @required this.folder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var historyBloc = BlocProvider.of<HistoryBloc>(context);
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionRemoveFolder),
      content: Text(AppLocalizations.of(context).dialogDeleteFolder),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          onPressed: () {
            _moveHistoriesToDefault(historyBloc);
            folderBloc.deleteFolder(folder.id);
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _moveHistoriesToDefault(HistoryBloc historyBloc) {
    var historyState = historyBloc.currentState;
    List<History> histories = (historyState is HistoryLoaded
        ? historyState.histories
            .where((history) => history.folderId == folder.id)
            .toList()
        : []);
    histories.forEach((history) {
      var updateHistory = history..folderId = 0;
      historyBloc.updateHistory(updateHistory);
    });
  }
}
