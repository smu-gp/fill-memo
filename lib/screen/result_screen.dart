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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TitleRow(
                  icon: Icons.date_range,
                  content:
                      "${Util.formatDate(widget.history.createdAt, 'MMMMEEEEd')}",
                ),
                SizedBox(height: 12.0),
                _TitleRow(
                  icon: Icons.access_time,
                  content:
                      "${Util.formatDate(widget.history.createdAt, 'a hh:mm')}",
                ),
                SizedBox(height: 12.0),
                _buildSubtitle(),
              ],
            ),
          ),
        ),
        minHeight: 120.0,
        maxHeight: 120.0,
      ),
    );
  }

  Widget _buildSubtitle() {
    return BlocBuilder<ResultEvent, ResultState>(
      bloc: _resultBloc,
      builder: (BuildContext context, ResultState state) {
        return _TitleRow(
          icon: Icons.receipt,
          content: AppLocalizations.of(context).resultCountMessage(
              state is ResultLoaded ? state.results.length : 0),
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

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String content;

  const _TitleRow({
    Key key,
    this.icon,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: 20.0,
          color: Theme.of(context).iconTheme.color,
        ),
        SizedBox(width: 16.0),
        Text(
          content,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
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
