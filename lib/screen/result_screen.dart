import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/bloc/history/history_bloc.dart';
import 'package:sp_client/bloc/result/result_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
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
  ResultBloc _resultBloc;

  @override
  void initState() {
    _resultBloc = BlocProvider.of<ResultBloc>(context)
      ..dispatch(LoadResults(
        historyId: widget.history.id,
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(),
            _buildTitle(),
            _buildDivider(),
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

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      elevation: 0.0,
      pinned: true,
      actions: _buildActions(),
      flexibleSpace: FlexibleSpaceBar(
        background: AspectRatio(
          child: HistoryImage(history: widget.history),
          aspectRatio: 3.0 / 4.0,
        ),
      ),
      expandedHeight: 224.0,
    );
  }

  Widget _buildTitle() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverPersistentTitleDelegate(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${Util.formatDate(widget.history.createdAt, 'MMMMEEEEd')}, "
                      "${Util.formatDate(widget.history.createdAt, 'a hh:mm')}",
                  style: Theme.of(context).textTheme.headline,
                ),
                SizedBox(
                  height: 8.0,
                ),
                _buildSubtitle(),
              ],
            ),
          ),
        ),
        minHeight: 96.0,
        maxHeight: 96.0,
      ),
    );
  }

  Widget _buildSubtitle() {
    return BlocBuilder<ResultEvent, ResultState>(
      bloc: _resultBloc,
      builder: (BuildContext context, ResultState state) {
        return Text(
          AppLocalizations.of(context).resultCountMessage(
              state is ResultLoaded ? state.results.length : 0),
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: Colors.white70,
              ),
        );
      },
    );
  }

  SliverToBoxAdapter _buildDivider() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: Colors.white54,
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      PopupMenuButton<ResultMenuItem>(
        itemBuilder: (context) => [
              PopupMenuItem<ResultMenuItem>(
                child: Text(AppLocalizations.of(context).actionDelete),
                height: 56.0,
                value: ResultMenuItem.actionDelete,
              ),
            ],
        onSelected: (selected) async {
          switch (selected) {
            case ResultMenuItem.actionDelete:
              bool isDeleteSelected = await showDialog(
                context: context,
                builder: (context) => DeleteItemDialog(
                      historyId: widget.history.id,
                    ),
              );
              if (isDeleteSelected) {
                BlocProvider.of<HistoryBloc>(context)
                    .dispatch(DeleteHistory(widget.history.id));
                BlocProvider.of<ResultBloc>(context)
                    .deleteResults(widget.history.id);
                Navigator.pop(context);
              }
              break;
            default:
              break;
          }
        },
      ),
    ];
  }
}

class _SliverPersistentTitleDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _SliverPersistentTitleDelegate({
    @required this.child,
    @required this.minHeight,
    @required this.maxHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => minHeight > maxHeight ? minHeight : maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_SliverPersistentTitleDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
