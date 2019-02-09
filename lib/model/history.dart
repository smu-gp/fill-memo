class History {
  static final String tableName = 'History';
  static final String columnId = '_id';
  static final String columnSourceImage = 'source_image';
  static final String columnCreatedAt = 'created_at';

  int id;
  String sourceImage;
  int createdAt;

  History({this.id, this.sourceImage, this.createdAt});

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
