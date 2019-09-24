import 'package:fill_memo/util/localization.dart';
import 'package:flutter/widgets.dart';

class ErrorMemo extends StatelessWidget {
  final Object exception;

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
