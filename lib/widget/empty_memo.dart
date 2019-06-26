import 'package:flutter/material.dart';
import 'package:sp_client/util/utils.dart';

class EmptyMemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("¯\\_(ツ)_/¯", style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 24.0),
          Text(AppLocalizations.of(context).memoEmpty),
        ],
      ),
    );
  }
}
