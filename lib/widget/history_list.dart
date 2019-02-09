import 'package:flutter/material.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/widget/history_item.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<History>>(
      stream: HistoryBlocProvider.of(context).allData,
      builder: (BuildContext context, AsyncSnapshot<List<History>> snapshot) =>
          snapshot.hasData && snapshot.data.isNotEmpty
              ? _buildList(snapshot.data)
              : Text('Empty data'),
    );
  }

  Widget _buildList(List<History> histories) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return GridView.count(
        crossAxisCount: (orientation == Orientation.portrait ? 2 : 4),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        padding: const EdgeInsets.only(
          left: 4.0,
          right: 4.0,
          top: 4.0,
          bottom: 80.0,
        ),
        children: histories.map<Widget>((history) {
          return HistoryItem(history);
        }).toList(),
      );
    });
  }
}
