class Folder {
  static final String tableName = "Folder";
  static final String columnId = "_id";
  static final String columnName = "name";

  int id;
  String name;

  Folder({this.id, this.name});

  Folder.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Folder{id: $id, name: $name}';
  }
}
