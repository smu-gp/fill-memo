import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/dependency_injection.dart';
import 'package:sp_client/localization.dart';
import 'package:sp_client/models.dart';

class ResultScreen extends StatefulWidget {
  final int historyId;

  ResultScreen({Key key, @required this.historyId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ResultBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var db = Injector.of(context).database;
    _bloc = ResultBloc(db);
    return Scaffold(
      body: Builder(
        builder: (context) => CustomScrollView(
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
                  sliver: _buildResults(context),
                )
              ],
            ),
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    _bloc.readByHistoryId(widget.historyId);
    return StreamBuilder(
        stream: _bloc.allData,
        builder: (context, AsyncSnapshot<List<Result>> snapshot) {
          if (snapshot.hasData) {
            var items = snapshot.data;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = items[index];
                  return ListTile(
                    leading: Text('#${index + 1}'),
                    title: (item.type == 'text'
                        ? Text(item.content)
                        : Image.network(item.content)),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: item.content));
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(item.content),
                      ));
                    },
                  );
                },
                childCount: items.length,
              ),
            );
          } else {
            return SliverList(
              delegate: SliverChildListDelegate([]),
            );
          }
        });
  }
}
