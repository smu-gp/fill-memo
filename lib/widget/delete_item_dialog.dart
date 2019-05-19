import 'package:flutter/material.dart';
import 'package:sp_client/util/localization.dart';

class DeleteItemDialog extends StatelessWidget {
  final int historyId;

  const DeleteItemDialog({
    Key key,
    @required this.historyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(AppLocalizations.of(context).dialogDeleteItem),
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
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
