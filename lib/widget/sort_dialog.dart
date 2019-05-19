import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';

class SortDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<HistoryBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionSort),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: BlocBuilder<HistoryEvent, HistoryState>(
        bloc: BlocProvider.of<HistoryBloc>(context),
        builder: (BuildContext context, HistoryState state) {
          return Wrap(
            children: <Widget>[
              RadioListTile<SortOrder>(
                  activeColor: Theme.of(context).accentColor,
                  title: Text(AppLocalizations.of(context).orderCreatedDes),
                  value: SortOrder.createdAtDes,
                  groupValue: (state is HistoryLoaded
                      ? state.order
                      : SortOrder.createdAtDes),
                  onChanged: (value) {
                    bloc.dispatch(LoadHistory(value));
                    Navigator.pop(context);
                  }),
              RadioListTile<SortOrder>(
                  activeColor: Theme.of(context).accentColor,
                  title: Text(AppLocalizations.of(context).orderCreatedAsc),
                  value: SortOrder.createdAtAsc,
                  groupValue: (state is HistoryLoaded
                      ? state.order
                      : SortOrder.createdAtDes),
                  onChanged: (value) {
                    bloc.dispatch(LoadHistory(value));
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      ),
    );
  }
}
