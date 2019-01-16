import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/localization.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              AppLocalizations.of(context).get('title_result'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            pinned: true,
            centerTitle: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _buildResultWidgets(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildResultWidgets() {
    return List<Widget>.generate(
        20,
        (index) => ListTile(
              title: Text('Result #$index'),
            ));
  }
}
