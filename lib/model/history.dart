import 'package:equatable/equatable.dart';

class History extends Equatable {
  static final String tableName = 'History';
  static final String columnId = '_id';
  static final String columnSourceImage = 'source_image';
  static final String columnCreatedAt = 'created_at';
  static final String columnFolderId = 'folder_id';

  int id;
  String sourceImage;
  int createdAt;
  int folderId;

  History({this.id, this.sourceImage, this.createdAt, this.folderId})
      : super([id, sourceImage, createdAt, folderId]);

  History.fromMap(Map<String, dynamic> map)
      : super([
          map[columnId],
          map[columnSourceImage],
          map[columnCreatedAt],
          map[columnFolderId]
        ]) {
    id = map[columnId];
    sourceImage = map[columnSourceImage];
    createdAt = map[columnCreatedAt];
    folderId = map[columnFolderId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSourceImage: sourceImage,
      columnCreatedAt: createdAt,
      columnFolderId: folderId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'History{id: $id, sourceImage: $sourceImage, createdAt: $createdAt, folderId: $folderId}';
  }
}
