import 'package:equatable/equatable.dart';

class Result extends Equatable {
  static final String tableName = 'Result';
  static final String columnId = '_id';
  static final String columnHistoryId = 'history_id';
  static final String columnType = 'type';
  static final String columnContent = 'content';

  int id;
  int historyId;
  String type;
  String content;

  Result({this.id, this.historyId, this.type, this.content})
      : super([id, historyId, type, content]);

  Result.fromMap(Map<String, dynamic> map)
      : super([
          map[columnId],
          map[columnHistoryId],
          map[columnType],
          map[columnContent]
        ]) {
    id = map[columnId];
    historyId = map[columnHistoryId];
    type = map[columnType];
    content = map[columnContent];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnHistoryId: historyId,
      columnType: type,
      columnContent: content,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
