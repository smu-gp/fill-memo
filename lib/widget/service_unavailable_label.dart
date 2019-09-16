import 'package:fill_memo/util/localization.dart';
import 'package:flutter/material.dart';

class ServiceUnavailableLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 48.0,
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error, color: theme.accentIconTheme.color),
            SizedBox(width: 24),
            Expanded(
              child: Text(
                AppLocalizations.of(context).labelServiceUnavailable,
                style: theme.accentTextTheme.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
