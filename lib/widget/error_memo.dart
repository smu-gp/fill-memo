import 'package:flutter/widgets.dart';
import 'package:sp_client/util/localization.dart';

class ErrorMemo extends StatelessWidget {
  final Exception exception;

  ErrorMemo([this.exception]);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(AppLocalizations.of(context).memoError),
          SizedBox(height: 8.0),
          if (exception != null) Text(exception.toString()),
        ],
      ),
    );
  }
}
