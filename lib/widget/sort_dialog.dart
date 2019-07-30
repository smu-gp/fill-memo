import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/sub_header.dart';

class SortDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionSort),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24.0,
        horizontal: 0.0,
      ),
      content: Consumer<MemoSort>(
        builder: (context, sortValue, _) {
          return Wrap(
            children: <Widget>[
              RadioListTile<SortOrderBy>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderByCreated),
                value: SortOrderBy.createdAt,
                groupValue: sortValue.orderBy,
                onChanged: (value) {
                  sortValue.orderBy = value;
                  Navigator.pop(context);
                },
              ),
              RadioListTile<SortOrderBy>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderByUpdated),
                value: SortOrderBy.updatedAt,
                groupValue: sortValue.orderBy,
                onChanged: (value) {
                  sortValue.orderBy = value;
                  Navigator.pop(context);
                },
              ),
              SubHeader(AppLocalizations.of(context).orderType),
              RadioListTile<SortOrderType>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderTypeAsc),
                value: SortOrderType.Asc,
                groupValue: sortValue.orderType,
                onChanged: (value) {
                  sortValue.orderType = value;
                  Navigator.pop(context);
                },
              ),
              RadioListTile<SortOrderType>(
                activeColor: Theme.of(context).accentColor,
                title: Text(AppLocalizations.of(context).orderTypeDes),
                value: SortOrderType.Des,
                groupValue: sortValue.orderType,
                onChanged: (value) {
                  sortValue.orderType = value;
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
