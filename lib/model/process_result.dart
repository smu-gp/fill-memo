class ProcessResult {
  static final String columnContent = 'content';

  String content;

  ProcessResult(this.content);

  ProcessResult.fromMap(Map<String, dynamic> map) {
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
