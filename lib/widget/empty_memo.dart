import 'package:flutter/material.dart';
import 'package:sp_client/util/utils.dart';

class EmptyMemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.description,
            color: Theme.of(context).iconTheme.color.withOpacity(0.54),
            size: 96.0,
          ),
          SizedBox(height: 24.0),
          Text(AppLocalizations.of(context).memoEmpty),
        ],
      ),
    );
  }
}
