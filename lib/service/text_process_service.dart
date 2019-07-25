import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

Future<List<ProcessResult>> sendImage({String baseUrl, File imageFile}) async {
  var requestImage = await http.MultipartFile.fromPath('image', imageFile.path);
  var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/process/"));
  request.files.add(requestImage);
  var response = await request.send();
  if (response.statusCode == 200) {
    var body = await response.stream.toStringStream().single;
    return (json.decode(body) as List)
        .map((item) => ProcessResult.fromMap(item))
        .toList();
  } else {
    return null;
  }
}

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
