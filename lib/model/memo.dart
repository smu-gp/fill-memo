import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sp_client/util/constants.dart';

class Memo extends Equatable {
  // Local database field constants for Secret folder
  static final String tableName = "memoSecret";
  static final String columnId = "id";
  static final String columnTitle = "title";
  static final String columnContent = "content";
  static final String columnContentStyle = "contentStyle";
  static final String columnType = "type";
  static final String columnCreatedAt = "createdAt";
  static final String columnUpdatedAt = "updatedAt";
  static final String columnFolderId = "folderId";

  // Cloud firestore field constants
  static final String collectionName = "memo";
  static final String columnUserId = "userId";

  String id;
  String userId;
  String folderId;
  String title;
  String content;
  String contentStyle;
  String type;
  int createdAt;
  int updatedAt;

  Memo({
    this.id,
    this.userId,
    this.folderId = kDefaultFolderId,
    this.title,
    @required this.content,
    this.contentStyle,
    @required this.type,
    @required this.createdAt,
    this.updatedAt,
  }) : super([
          id,
          userId,
          folderId,
          title,
          content,
          contentStyle,
          type,
          createdAt,
          updatedAt
        ]);

  Memo.fromMap(Map<String, dynamic> map)
      : super([
          map[columnId],
          map[columnUserId],
          map[columnFolderId],
          map[columnTitle],
          map[columnContent],
          map[columnContentStyle],
          map[columnType],
          map[columnCreatedAt],
          map[columnUpdatedAt],
        ]) {
    id = map[columnId];
    userId = map[columnUserId];
    folderId = map[columnFolderId];
    title = map[columnTitle];
    content = map[columnContent];
    contentStyle = map[columnContentStyle];
    type = map[columnType];
    createdAt = map[columnCreatedAt];
    updatedAt = map[columnUpdatedAt];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[columnId] = id;
    map[columnUserId] = userId;
    map[columnTitle] = title;
    map[columnContent] = content;
    map[columnContentStyle] = contentStyle;
    map[columnType] = type;
    map[columnCreatedAt] = createdAt;
    map[columnFolderId] = folderId;
    map[columnUpdatedAt] = updatedAt;
    return map;
  }

  @override
  String toString() {
    return 'Memo{id: $id, userId: $userId, folderId: $folderId, title: $title, content: $content, contentStyle: $contentStyle, type: $type, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
