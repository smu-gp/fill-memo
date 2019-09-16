import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sub_header.dart';

class MemoSortPanel extends StatelessWidget {
  final VoidCallback onSortSelected;

  MemoSortPanel({this.onSortSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoSort>(
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
                if (onSortSelected != null) {
                  onSortSelected();
                }
              },
            ),
            RadioListTile<SortOrderBy>(
              activeColor: Theme.of(context).accentColor,
              title: Text(AppLocalizations.of(context).orderByUpdated),
              value: SortOrderBy.updatedAt,
              groupValue: sortValue.orderBy,
              onChanged: (value) {
                sortValue.orderBy = value;
                if (onSortSelected != null) {
                  onSortSelected();
                }
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
                if (onSortSelected != null) {
                  onSortSelected();
                }
              },
            ),
            RadioListTile<SortOrderType>(
              activeColor: Theme.of(context).accentColor,
              title: Text(AppLocalizations.of(context).orderTypeDes),
              value: SortOrderType.Des,
              groupValue: sortValue.orderType,
              onChanged: (value) {
                sortValue.orderType = value;
                if (onSortSelected != null) {
                  onSortSelected();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
