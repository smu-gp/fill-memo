import 'package:equatable/equatable.dart';

class ProcessResult extends Equatable {
  static final String columnContent = 'content';

  String content;

  ProcessResult({this.content}) : super([content]);

  ProcessResult.fromMap(Map<String, dynamic> map)
      : super([map[columnContent]]) {
    content = map[columnContent];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
    };
    return map;
  }

  @override
  String toString() {
    return '$runtimeType(content: $content)';
  }
}
