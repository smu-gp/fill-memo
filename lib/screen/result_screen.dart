import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/delete_item_dialog.dart';
import 'package:sp_client/widget/history_image.dart';
import 'package:sp_client/widget/result_list.dart';

class ResultScreen extends StatefulWidget {
  final History history;

  ResultScreen({
    Key key,
    @required this.history,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                AppLocalizations.of(context).titleResult,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              pinned: true,
              actions: _buildActions(),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 160.0,
                child: AspectRatio(
                  child: HistoryImage(history: widget.history),
                  aspectRatio: 3.0 / 4.0,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: ResultList(
                historyId: widget.history.id,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(OMIcons.delete),
        onPressed: () async {
          bool isDeleteSelected = await showDialog(
            context: context,
            builder: (context) => DeleteItemDialog(
                  historyId: widget.history.id,
                ),
          );
          if (isDeleteSelected) {
            BlocProvider.of<HistoryBloc>(context)
                .deleteHistory(widget.history.id);
            BlocProvider.of<ResultBloc>(context)
                .deleteResultByHistoryId(widget.history.id);
            Navigator.pop(context);
          }
        },
      ),
    ];
  }
}
