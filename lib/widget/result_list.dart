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
    var resultBloc = BlocProvider.of<ResultBloc>(context)
      ..dispatch(LoadResults(
        historyId: historyId,
      ));
    return BlocBuilder<ResultEvent, ResultState>(
        bloc: resultBloc,
        builder: (BuildContext context, ResultState state) {
          return SliverList(
            delegate: SliverChildListDelegate(_buildList(state)),
          );
        });
  }

  List<Widget> _buildList(ResultState state) {
    if (state is ResultLoaded) {
      int index = 0;
      return state.results.map((result) {
        return ResultItem(
          index: index++,
          result: result,
        );
      }).toList();
    } else {
      return [
        CircularProgressIndicator(),
      ];
    }
  }
}
