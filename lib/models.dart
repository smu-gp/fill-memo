class History {
  static final String tableName = 'History';
  static final String columnId = '_id';
  static final String columnSourceImage = 'source_image';
  static final String columnCreatedAt = 'created_at';

  int id;
  String sourceImage;
  int createdAt;

  History();

  History.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    sourceImage = map[columnSourceImage];
    createdAt = map[columnCreatedAt];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSourceImage: sourceImage,
      columnCreatedAt: createdAt,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class Result {
  static final String tableName = 'Result';
  static final String columnId = '_id';
  static final String columnHistoryId = 'history_id';
  static final String columnType = 'type';
  static final String columnContent = 'content';

  int id;
  int historyId;
  String type;
  String content;

  Result();

  Result.fromMap(Map<String, dynamic> map) {
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

enum SortOrder { dateAsc, dateDes }
