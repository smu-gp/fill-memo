import 'dart:async';

import 'package:universal_html/html.dart' as html;

import '../image_model.dart';

Future<ImageObject> pickImage(ImageSource imageSource) async {
  if (imageSource == ImageSource.gallery) {
    final completer = Completer<ImageObject>();
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/jpeg, image/png';
    input.onChange.listen((event) async {
      final file = input.files.first;
      completer.complete(ImageObject(file, file.name));
    });
    input.click();
    return completer.future;
  } else {
    throw UnsupportedError('Not support camera on web');
  }
}
