import 'package:fill_memo/util/util.dart';

enum ListType { grid, list }

class MemoListType extends SingleChangeNotifier<ListType> {
  MemoListType([ListType value = ListType.grid]) : super(value);
}
