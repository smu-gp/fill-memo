import 'dart:convert';

import 'package:fill_memo/model/process_result.dart';
import 'package:http/http.dart' as http;

Future<List<ProcessResult>> sendImage({
  String baseUrl,
  String imagePath,
}) async {
  var sendImage = await http.MultipartFile.fromPath('image', imagePath);
  var request = http.MultipartRequest(
    "POST",
    Uri.parse("$baseUrl/process/"),
  )..files.add(sendImage);

  var response = await request.send();
  if (response.statusCode == 200) {
    var bodyStream = response.stream.toStringStream();
    var responseBody = "";
    await for (var body in bodyStream) {
      responseBody += body;
    }

    if (responseBody.isNotEmpty) {
      return (json.decode(responseBody) as List)
          .map((item) => ProcessResult.fromMap(item))
          .toList();
    } else {
      return null;
    }
  } else {
    return null;
  }
}
