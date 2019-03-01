import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/model/sort_order.dart';
import 'package:sp_client/util/localization.dart';

class SortDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<HistoryBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionSort),
      backgroundColor: Theme.of(context).backgroundColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: BlocBuilder<HistoryEvent, HistoryState>(
        bloc: BlocProvider.of<HistoryBloc>(context),
        builder: (BuildContext context, HistoryState state) {
          if (state is HistoryLoaded) {
            return Wrap(
              children: <Widget>[
                RadioListTile<SortOrder>(
                    activeColor: Theme.of(context).accentColor,
                    title: Text(AppLocalizations.of(context).orderCreatedDes),
                    value: SortOrder.createdAtDes,
                    groupValue: state.order,
                    onChanged: (value) {
                      bloc.dispatch(FetchHistory(order: value));
                      Navigator.pop(context);
                    }),
                RadioListTile<SortOrder>(
                    activeColor: Theme.of(context).accentColor,
                    title: Text(AppLocalizations.of(context).orderCreatedAsc),
                    value: SortOrder.createdAtAsc,
                    groupValue: state.order,
                    onChanged: (value) {
                      bloc.dispatch(FetchHistory(order: value));
                      Navigator.pop(context);
                    }),
              ],
            );
          }
        },
      ),
    );
  }
}
