import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
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
    var listBloc = BlocProvider.of<ListBloc>(context);

    return BlocBuilder<MemoBloc, MemoState>(
      builder: (context, memoState) {
        if (memoState is MemosLoaded) {
          return Consumer<MemoSort>(
            builder: (context, sortValue, _) {
              var memoList = _sortMemos(
                memoState.memos,
                orderBy: sortValue.orderBy,
                type: sortValue.orderType,
              );

              if (folderId != null) {
                memoList = _filterMemos(memoList, folderId: folderId);
              }

              if (memoList.isEmpty) {
                return EmptyMemo();
              }

              return BlocBuilder<ListBloc, ListState>(
                bloc: listBloc,
                builder: (context, memoListState) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _buildGrid(
                      memoList,
                      listBloc: listBloc,
                      listState: memoListState,
                      orderType: sortValue.orderType,
                    ),
                  );
                },
              );
            },
          );
        } else if (memoState is MemosNotLoaded) {
          return ErrorMemo(memoState.exception);
        } else {
          return LoadingProgress();
        }
      },
    );
  }

  Widget _buildGrid(
    List<Memo> memoList, {
    ListBloc listBloc,
    ListState listState,
    SortOrderType orderType,
  }) {
    return StaggeredGridView.countBuilder(
      primary: false,
      crossAxisCount: 4,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 2.0,
      itemCount: memoList.length,
      itemBuilder: (context, index) {
        var memo = memoList[index];
        var selected = false;
        if (listState is SelectableList) {
          selected = listState.selectedItems.contains(memo);
        }
        return MemoItem(
          memo,
          date: orderType == SortOrderBy.updatedAt ? memo.updatedAt : null,
          selected: selected,
          onTap: () {
            if (listState is SelectableList) {
              if (selected) {
                listBloc.dispatch(UnSelectItem(memo));
              } else {
                listBloc.dispatch(SelectItem(memo));
              }
            } else {
              Navigator.push(context, Routes().memo(context, memo));
            }
          },
          onLongPress: () => listBloc.dispatch(SelectItem(memo)),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    );
  }

  List<Memo> _sortMemos(List<Memo> memos,
      {SortOrderBy orderBy, SortOrderType type}) {
    memos.sort((a, b) {
      if (orderBy == SortOrderBy.createdAt) {
        if (type == SortOrderType.Asc) {
          return a.createdAt.compareTo(b.createdAt);
        } else {
          return b.createdAt.compareTo(a.createdAt);
        }
      } else if (orderBy == SortOrderBy.updatedAt) {
        if (type == SortOrderType.Asc) {
          return a.updatedAt.compareTo(b.updatedAt);
        } else {
          return b.updatedAt.compareTo(a.updatedAt);
        }
      }
      return 0;
    });
    return memos;
  }

  List<Memo> _filterMemos(List<Memo> memos, {String folderId}) {
    return memos.where((memo) {
      return memo.folderId == folderId;
    }).toList();
  }
}
