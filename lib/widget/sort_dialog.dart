import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/sub_header.dart';

class SortDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MemoSortBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionSort),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: BlocBuilder<MemoSortBloc, MemoSortState>(
        bloc: bloc,
        builder: (BuildContext context, MemoSortState state) {
          return Wrap(
            children: <Widget>[
              RadioListTile<SortOrderBy>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderByCreated),
                value: SortOrderBy.createdAt,
                groupValue: state.orderBy,
                onChanged: (value) {
                  bloc.dispatch(ChangeSort(
                    orderBy: SortOrderBy.createdAt,
                    sortType: state.sortType,
                  ));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<SortOrderBy>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderByUpdated),
                value: SortOrderBy.updatedAt,
                groupValue: state.orderBy,
                onChanged: (value) {
                  bloc.dispatch(ChangeSort(
                    orderBy: SortOrderBy.updatedAt,
                    sortType: state.sortType,
                  ));
                  Navigator.pop(context);
                },
              ),
              SubHeader(AppLocalizations.of(context).orderType),
              RadioListTile<SortOrderType>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderTypeAsc),
                value: SortOrderType.Asc,
                groupValue: state.sortType,
                onChanged: (value) {
                  bloc.dispatch(ChangeSort(
                    orderBy: state.orderBy,
                    sortType: SortOrderType.Asc,
                  ));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<SortOrderType>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderTypeDes),
                value: SortOrderType.Des,
                groupValue: state.sortType,
                onChanged: (value) {
                  bloc.dispatch(ChangeSort(
                    orderBy: state.orderBy,
                    sortType: SortOrderType.Des,
                  ));
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
