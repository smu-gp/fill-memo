import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/bloc/result_bloc_provider.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/util/localization.dart';

class HistoryItem extends StatelessWidget {
  final History history;

  HistoryItem(
    this.history, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var historyBloc = HistoryBlocProvider.of(context);
    var resultBloc = ResultBlocProvider.of(context);
    return GridTile(
      child: Ink.image(
        image: FileImage(File(history.sourceImage)),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () {},
        ),
      ),
      footer: GridTileBar(
        title: Text(
            DateTime.fromMillisecondsSinceEpoch(history.createdAt).toString()),
        backgroundColor: Colors.black45,
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            historyBloc.delete(history.id);
            Scaffold.of(context)
                .showSnackBar(_buildDeleteHistorySnackBar(context, history))
                .closed
                .then((reason) {
              if (reason == SnackBarClosedReason.timeout ||
                  reason == SnackBarClosedReason.swipe) {
                resultBloc.deleteByHistoryId(history.id);
              } else if (reason == SnackBarClosedReason.action) {
                historyBloc.create(history);
              }
            });
          },
        ),
      ),
    );
  }

  _buildDeleteHistorySnackBar(BuildContext context, History history) {
    return SnackBar(
      content: Text(AppLocalizations.of(context)
          .get('item_deleted')
          .replaceFirst(
              '\$',
              DateTime.fromMillisecondsSinceEpoch(history.createdAt)
                  .toString())),
      action: SnackBarAction(
        label: AppLocalizations.of(context).get('undo'),
        onPressed: () {},
      ),
    );
  }
}
