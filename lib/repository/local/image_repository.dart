import 'dart:io';

import 'package:meta/meta.dart';

class LocalImageRepository {
  final Directory imageDirectory;

  LocalImageRepository({
    @required this.imageDirectory,
  });

  Future<String> addImage(File file) async {
    var currentDate = DateTime.now().millisecondsSinceEpoch;
    var fileExt = file.path.split(".")?.last;
    var copiedPath = "${imageDirectory.path}/$currentDate.$fileExt";

    File copiedFile = await _copyFile(file, copiedPath);
    return copiedFile.path;
  }

  Future<File> _copyFile(File src, String destPath) async {
    var bytes = await src.readAsBytes();
    return File(destPath).writeAsBytes(bytes);
  }

  static void deleteImage(String filePath) {
    var file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }
}
