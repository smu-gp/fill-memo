import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/widget/result_item.dart';

class ResultList extends StatelessWidget {
  final int historyId;

  const ResultList({
    Key key,
    @required this.historyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultEvent, ResultState>(
        bloc: BlocProvider.of<ResultBloc>(context),
        builder: (BuildContext context, ResultState state) {
          return SliverList(
            delegate: SliverChildListDelegate(_buildList(context, state)),
          );
        });
  }

  List<Widget> _buildList(BuildContext context, ResultState state) {
    if (state is ResultLoaded) {
      int index = 0;
      return ListTile.divideTiles(
        context: context,
        tiles: state.results.map((result) {
          return ResultItem(
            index: index++,
            result: result,
          );
        }).toList(),
      ).toList();
    } else {
      return [
        CircularProgressIndicator(),
      ];
    }
  }
}
