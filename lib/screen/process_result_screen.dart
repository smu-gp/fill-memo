import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/process_result.dart';
import 'package:flutter/material.dart';

class ProcessResultScreen extends StatefulWidget {
  final List<ProcessResult> results;

  ProcessResultScreen(this.results, {Key key}) : super(key: key);

  @override
  _ProcessResultScreenState createState() => _ProcessResultScreenState();
}

class _ProcessResultScreenState extends State<ProcessResultScreen> {
  GlobalKey<ProcessResultPanelState> _processResultPanelKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var title = localizations.titleResult;

    Widget child = ProcessResultPanel(
      key: _processResultPanelKey,
      results: widget.results,
    );

    if (Util.isLarge(context)) {
      child = AlertDialog(
        title: Text(title),
        contentPadding: EdgeInsets.symmetric(
          vertical: Dimensions.keyline,
        ),
        content: Container(
          width: Dimensions.dialogWidth(context),
          height: Dimensions.dialogListHeight,
          child: child,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              MaterialLocalizations.of(context).cancelButtonLabel,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text(AppLocalizations.of(context).actionAdd),
            onPressed: () {
              Navigator.pop(
                context,
                _processResultPanelKey.currentState.selectedItems,
              );
            },
          ),
        ],
      );
    } else {
      child = Scaffold(
        appBar: AppBar(
          title: Text(title),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).actionAdd),
              onPressed: () {
                Navigator.pop(
                  context,
                  _processResultPanelKey.currentState.selectedItems,
                );
              },
            )
          ],
        ),
        body: child,
      );
    }
    return child;
  }
}
