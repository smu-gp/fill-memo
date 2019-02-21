import 'package:flutter/material.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/result_list.dart';

class ResultScreen extends StatefulWidget {
  final int historyId;

  ResultScreen({Key key, @required this.historyId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    AppLocalizations.of(context).titleResult,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  pinned: true,
                  centerTitle: true,
                ),
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: ResultList(
                    historyId: widget.historyId,
                  ),
                )
              ],
            ),
      ),
    );
  }
}
