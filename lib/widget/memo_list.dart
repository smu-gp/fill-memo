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

    return BlocBuilder<MemoEvent, MemoState>(
      bloc: memoBloc,
      builder: (context, memoState) {
        if (memoState is MemoLoaded) {
          return BlocBuilder<MemoSortEvent, MemoSortState>(
            bloc: memoSortBloc,
            builder: (context, memoSortState) {
              // Sort memo
              var memoList = memoState.memoList;
              memoList.sort((a, b) {
                if (memoSortState.orderBy == SortOrderBy.createdAt) {
                  if (memoSortState.sortType == SortOrderType.Asc) {
                    return a.createdAt.compareTo(b.createdAt);
                  } else {
                    return b.createdAt.compareTo(a.createdAt);
                  }
                } else if (memoSortState.orderBy == SortOrderBy.updatedAt) {
                  if (memoSortState.sortType == SortOrderType.Asc) {
                    return a.updatedAt.compareTo(b.updatedAt);
                  } else {
                    return b.updatedAt.compareTo(a.updatedAt);
                  }
                }
                return 0;
              });

              // Filter memo
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
                    child: _buildGrid(memoList, memoSortState, listBloc),
                  );
                },
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
  }

  StaggeredGridView _buildGrid(
    List<Memo> memoList,
    MemoSortState sortState,
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
        var listState = listBloc.currentState;
        if (listState is SelectableList) {
          selected = listState.selectedItems.contains(memo);
        }
        return MemoItem(
          memo,
          date: sortState.orderBy == SortOrderBy.updatedAt
              ? memo.updatedAt
              : null,
          selected: selected,
          onTap: () {
            if (listState is SelectableList) {
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
