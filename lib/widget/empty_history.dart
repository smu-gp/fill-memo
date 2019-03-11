import 'package:flutter/material.dart';
import 'package:sp_client/util/utils.dart';

class EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context).historyEmpty),
    );
  }
}
