import 'package:flutter/material.dart';
import 'package:sp_client/localizations.dart';

class ResultScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).get('title')),
      ),
      body: _buildResultWidgets(),
    );
  }

  Widget _buildResultWidgets() {
    var results = List<String>.generate(3, (index) => 'Result #$index');
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(results[index]),
            ));
  }
}
