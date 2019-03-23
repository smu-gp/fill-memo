import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:sp_client/model/models.dart';

class ProcessingService {
  final String baseUrl;
  final http.Client httpClient;

  ProcessingService({
    this.baseUrl,
    this.httpClient,
  });

  Future<List<Result>> sendImage({
    File imageFile,
    double cropLeft,
    double cropTop,
    double cropRight,
    double cropBottom,
  }) async {
    try {
      var requestImage =
          await http.MultipartFile.fromPath('image', imageFile.path);
      var request =
          http.MultipartRequest("POST", Uri.parse("$baseUrl/process"));
      request.fields['cropLeft'] = cropLeft.toString();
      request.fields['cropTop'] = cropTop.toString();
      request.fields['cropRight'] = cropRight.toString();
      request.fields['cropBottom'] = cropBottom.toString();
      request.files.add(requestImage);
      var response = await request.send();
      if (response.statusCode == 200) {
        var body = await response.stream.toStringStream().single;
        return (json.decode(body) as List)
            .map((item) => Result.fromMap(item))
            .toList();
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }
}
