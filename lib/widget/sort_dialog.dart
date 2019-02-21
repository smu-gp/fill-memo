import 'package:flutter/material.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/util/localization.dart';

class SortDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = HistoryBlocProvider.of(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionSort),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: StreamBuilder<SortOrder>(
          stream: bloc.activeSortOrder,
          builder: (context, snapshot) {
            return Wrap(
              children: <Widget>[
                RadioListTile<SortOrder>(
                    activeColor: Theme.of(context).accentColor,
                    title: Text(AppLocalizations.of(context).orderCreatedDes),
                    value: SortOrder.createdAtDes,
                    groupValue: snapshot.data,
                    onChanged: (value) {
                      bloc.updateSort(value);
                      Navigator.pop(context);
                    }),
                RadioListTile<SortOrder>(
                    activeColor: Theme.of(context).accentColor,
                    title: Text(AppLocalizations.of(context).orderCreatedAsc),
                    value: SortOrder.createdAtAsc,
                    groupValue: snapshot.data,
                    onChanged: (value) {
                      bloc.updateSort(value);
                      Navigator.pop(context);
                    }),
              ],
            );
          }),
    );
  }
}
