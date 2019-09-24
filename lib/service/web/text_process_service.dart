import 'dart:convert';

import 'package:fill_memo/model/process_result.dart';
import 'package:fill_memo/service/image_model.dart';
import 'package:universal_html/html.dart';

Future<List<ProcessResult>> sendImage({
  String baseUrl,
  ImageObject imageObject,
}) async {
  var imageFormData = FormData();
  imageFormData.append('image', imageObject.file);
  var request = await HttpRequest.request(
    '$baseUrl/process/',
    method: 'POST',
    sendData: imageFormData,
  );

  if (request.status == 200) {
    return (json.decode(request.response) as List)
        .map((item) => ProcessResult.fromMap(item))
        .toList();
  } else {
    return null;
  }
}
