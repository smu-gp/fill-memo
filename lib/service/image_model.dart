enum ImageSource {
  // Support app & web
  gallery,
  // Not support web
  camera,
}

class ImageResult {
  final Object file;
  final String path;

  ImageResult(this.file, this.path);

  @override
  String toString() {
    return '$runtimeType(file: $file, path: $path)';
  }
}
