import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/util/util.dart';
import 'package:sp_client/widget/empty_history.dart';
import 'package:sp_client/widget/history_item.dart';
import 'package:sp_client/widget/loading_progress.dart';
import 'package:sp_client/widget/sub_header.dart';

class HistoryList extends StatelessWidget {
  final int folderId;

  HistoryList({this.folderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryEvent, HistoryState>(
      bloc: BlocProvider.of<HistoryBloc>(context),
      builder: (BuildContext context, HistoryState state) {
        if (state is HistoryLoaded) {
          var histories = state.histories.where(
              (history) => (folderId == null || history.folderId == folderId));
          if (histories.isNotEmpty) {
            return OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
              return CustomScrollView(
                slivers: _buildList(histories.toList(), orientation),
              );
            });
          } else {
            return EmptyHistory();
          }
        } else if (state is HistoryLoading) {
          return LoadingProgress();
        } else if (state is HistoryEmpty) {
          return EmptyHistory();
        }
      },
    );
  }

  List<Widget> _buildList(List<History> histories, Orientation orientation) {
    var items = List<Widget>();
    groupBy(
      histories,
      (History history) => Util.formatDate(history.createdAt, 'MMMMEEEEd'),
    ).forEach((date, histories) {
      items
        ..add(
          SubHeader(date),
        )
        ..add(
          _buildGrid(histories, orientation),
        );
    });
    items.add(
      SliverToBoxAdapter(
        child: SizedBox(
          height: 80.0,
        ),
      ),
    );
    return items;
  }

  Widget _buildGrid(List<History> histories, Orientation orientation) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
      sliver: SliverGrid.count(
        crossAxisCount: (orientation == Orientation.portrait ? 3 : 5),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: histories.map<Widget>((history) {
          return HistoryItem(history);
        }).toList(),
      ),
    );
  }
}
