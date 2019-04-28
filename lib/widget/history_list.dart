import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/util/util.dart';
import 'package:sp_client/widget/empty_history.dart';
import 'package:sp_client/widget/history_item.dart';
import 'package:sp_client/widget/loading_progress.dart';
import 'package:sp_client/widget/sub_header.dart';

class HistoryList extends StatelessWidget {
  final int folderId;

  const HistoryList({
    Key key,
    this.folderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var historyBloc = BlocProvider.of<HistoryBloc>(context);
    var historyListBloc = BlocProvider.of<HistoryListBloc>(context);
    return BlocBuilder<HistoryEvent, HistoryState>(
      bloc: historyBloc,
      builder: (BuildContext context, HistoryState state) {
        if (state is HistoryLoaded) {
          var histories = state.histories.where(
              (history) => (folderId == null || history.folderId == folderId));
          if (histories.isNotEmpty) {
            return OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
              return CustomScrollView(
                slivers: _buildList(
                  context: context,
                  listBloc: historyListBloc,
                  histories: histories.toList(),
                  orientation: orientation,
                ),
              );
            });
          } else {
            return EmptyHistory();
          }
        } else if (state is HistoryLoading) {
          return LoadingProgress();
        }
      },
    );
  }

  List<Widget> _buildList({
    BuildContext context,
    HistoryListBloc listBloc,
    List<History> histories,
    Orientation orientation,
  }) {
    var items = List<Widget>()
      ..add(SliverToBoxAdapter(
        child: SizedBox(
          height: 16.0,
        ),
      ));
    groupBy(
      histories,
      (History history) => Util.formatDate(history.createdAt, 'MMMMEEEEd'),
    ).forEach((date, histories) {
      items
        ..add(
          SliverToBoxAdapter(
            child: SubHeader(
              date,
              padding: Util.isTablet(context) ? 32.0 : 16.0,
            ),
          ),
        )
        ..add(
          _buildGrid(listBloc, histories, orientation),
        );
    });
    items.add(
      SliverToBoxAdapter(child: SizedBox(height: 80.0)),
    );
    return items;
  }

  Widget _buildGrid(HistoryListBloc listBloc, List<History> histories,
      Orientation orientation) {
    return BlocBuilder<HistoryListEvent, HistoryListState>(
        bloc: listBloc,
        builder: (BuildContext context, HistoryListState state) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: Util.isTablet(context) ? 32.0 : 16.0,
                vertical: 0.0),
            sliver: SliverGrid.count(
              crossAxisCount: (Util.isTablet(context)
                  ? 6
                  : orientation == Orientation.portrait ? 3 : 5),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: histories.map<Widget>((history) {
                return HistoryItem(
                  history: history,
                  selectable: (state is SelectableList),
                  selected: (state is SelectableList
                      ? state.selectedItems.contains(history)
                      : false),
                );
              }).toList(),
            ),
          );
        });
  }
}
