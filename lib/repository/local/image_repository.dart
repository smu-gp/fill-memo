import 'dart:io';

import 'package:meta/meta.dart';

class LocalImageRepository {
  final Directory imageDirectory;

  LocalImageRepository({
    @required this.imageDirectory,
  });

  Future<String> addImage(int currentTime, File file) async {
    var fileExt = file.path.split(".")?.last;
    var copiedPath = "${imageDirectory.path}/$currentTime.$fileExt";

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
