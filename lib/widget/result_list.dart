import 'package:flutter/material.dart';
import 'package:sp_client/bloc/result_bloc_provider.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/widget/result_item.dart';

class ResultList extends StatelessWidget {
  final int historyId;

  const ResultList({
    Key key,
    @required this.historyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = ResultBlocProvider.of(context)..readByHistoryId(historyId);
    return StreamBuilder(
        stream: bloc.allData,
        builder: (context, AsyncSnapshot<List<Result>> snapshot) {
          if (snapshot.hasData) {
            var items = snapshot.data;
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var item = items[index];
                  return ResultItem(
                    index: index,
                    result: item,
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
