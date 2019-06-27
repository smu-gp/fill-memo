import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/memo_screen.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/widget/empty_memo.dart';
import 'package:sp_client/widget/error_memo.dart';
import 'package:sp_client/widget/loading_progress.dart';

import 'memo_item.dart';

class MemoList extends StatelessWidget {
  final String folderId;

  const MemoList({
    Key key,
    this.folderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var memoBloc = BlocProvider.of<MemoBloc>(context);
    var listBloc = BlocProvider.of<ListBloc>(context);
    var memoSortBloc = BlocProvider.of<MemoSortBloc>(context);

    return BlocBuilder<MemoSortEvent, MemoSortState>(
        bloc: memoSortBloc,
        builder: (context, memoSortState) {
          return BlocBuilder<MemoEvent, MemoState>(
            bloc: memoBloc,
            builder: (context, memoState) {
              if (memoState is MemoLoaded) {
                var memoList = memoState.memoList;
                memoList.sort((a, b) {
                  if (memoSortState.order == SortOrder.createdAtAsc) {
                    return a.createdAt.compareTo(b.createdAt);
                  } else {
                    return b.createdAt.compareTo(a.createdAt);
                  }
                });

                if (folderId != null) {
                  memoList = memoList.where((memo) {
                    if (folderId == kDefaultFolderId) {
                      return memo.folderId == null;
                    } else {
                      return memo.folderId == folderId;
                    }
                  }).toList();
                }

                if (memoList.isEmpty) {
                  return EmptyMemo();
                }

                return BlocBuilder<ListEvent, ListState>(
                  bloc: listBloc,
                  builder: (context, memoListState) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildGrid(memoList, memoListState, listBloc),
                    );
                  },
                );
              } else if (memoState is MemoNotLoaded) {
                return ErrorMemo(memoState.exception);
              } else {
                return LoadingProgress();
              }
            },
          );
        });
  }

  StaggeredGridView _buildGrid(
    List<Memo> memoList,
    ListState memoListState,
    ListBloc listBloc,
  ) {
    return StaggeredGridView.countBuilder(
      primary: false,
      crossAxisCount: 4,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      itemCount: memoList.length,
      itemBuilder: (context, index) {
        var memo = memoList[index];
        var selected = false;
        if (memoListState is SelectableList) {
          selected = memoListState.selectedItems.contains(memo);
        }
        return MemoItem(
          memo: memo,
          selected: selected,
          onTap: () {
            if (memoListState is SelectableList) {
              if (selected) {
                listBloc.dispatch(UnSelectItem(memo));
              } else {
                listBloc.dispatch(SelectItem(memo));
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MemoScreen(memo),
                ),
              );
            }
          },
          onLongPress: () => listBloc.dispatch(SelectItem(memo)),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    );
  }
}
