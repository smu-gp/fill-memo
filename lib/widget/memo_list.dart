import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import 'empty_memo.dart';
import 'error_memo.dart';
import 'loading_progress.dart';
import 'memo_grid_tile.dart';
import 'memo_list_tile.dart';

typedef MemoTapCallback = void Function(Memo, bool selectable, bool selected);

typedef MemoLongPressCallback = void Function(Memo, bool selectable);

class MemoList extends StatelessWidget {
  final String folderId;
  final ListType listType;
  final MemoTapCallback onTap;
  final MemoLongPressCallback onLongPress;

  MemoList({
    Key key,
    this.folderId,
    this.listType,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoBloc, MemoState>(
      builder: (context, memoState) {
        return Consumer<MemoSort>(
          builder: (context, sort, child) {
            if (memoState is MemosLoaded) {
              var memos = List.from(memoState.memos);

              // Filter folder memo
              if (folderId != null) {
                memos.retainWhere((memo) => memo.folderId == folderId);
              }

              if (memos.isEmpty) {
                return EmptyMemo();
              }

              memos.sort((a, b) => _compareMemo(a, b, sort));

              return BlocBuilder<ListBloc, ListState>(
                builder: (context, listState) {
                  var itemBuilder = (context, index) {
                    var selectable = false;
                    var selected = false;
                    var memo = memos[index];

                    if (listState is SelectableList) {
                      selectable = true;
                      selected = listState.selectedItems.contains(memo);
                    }

                    if (listType == ListType.list) {
                      return MemoListTile(
                        memo: memo,
                        useUpdatedAt: sort.orderBy == SortOrderBy.updatedAt,
                        selected: selected,
                        onTap: () => onTap(memo, selectable, selected),
                        onLongPress: () => onLongPress(memo, selectable),
                      );
                    } else {
                      return MemoGridTile(
                        memo: memo,
                        useUpdatedAt: sort.orderBy == SortOrderBy.updatedAt,
                        selected: selected,
                        onTap: () => onTap(memo, selectable, selected),
                        onLongPress: () => onLongPress(memo, selectable),
                      );
                    }
                  };

                  if (listType == ListType.list) {
                    return ListView.separated(
                      itemBuilder: itemBuilder,
                      itemCount: memos.length,
                      separatorBuilder: (context, index) => Divider(height: 2),
                    );
                  } else {
                    return StaggeredGridView.countBuilder(
                      itemBuilder: itemBuilder,
                      itemCount: memos.length,
                      crossAxisCount: Dimensions.gridCrossAxisCount(context),
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    );
                  }
                },
              );
            } else if (memoState is MemosNotLoaded) {
              return ErrorMemo(memoState.exception);
            } else {
              return LoadingProgress();
            }
          },
        );
      },
    );
  }

  int _compareMemo(Memo a, Memo b, MemoSort sort) {
    if (sort.orderBy == SortOrderBy.createdAt) {
      if (sort.orderType == SortOrderType.Asc) {
        return a.createdAt.compareTo(b.createdAt);
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    } else if (sort.orderBy == SortOrderBy.updatedAt) {
      if (sort.orderType == SortOrderType.Asc) {
        return a.updatedAt.compareTo(b.updatedAt);
      } else {
        return b.updatedAt.compareTo(a.updatedAt);
      }
    }
    return 0;
  }
}
