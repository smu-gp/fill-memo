import 'package:flutter/foundation.dart';

enum SortOrderBy { createdAt, updatedAt }

enum SortOrderType { Asc, Des }

class MemoSort with ChangeNotifier {
  SortOrderBy _orderBy = SortOrderBy.createdAt;
  SortOrderType _orderType = SortOrderType.Des;

  SortOrderBy get orderBy => _orderBy;

  set orderBy(SortOrderBy newOrderBy) {
    _orderBy = newOrderBy;
    notifyListeners();
  }

  SortOrderType get orderType => _orderType;

  set orderType(SortOrderType newOrderType) {
    _orderType = newOrderType;
    notifyListeners();
  }
}
