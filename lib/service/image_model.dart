enum ImageSource {
  // Support app & web
  gallery,
  // Not support web
  camera,
}

class ImageObject {
  final Object file;
  final String path;

  ImageObject(this.file, this.path);

  @override
  String toString() {
    return '$runtimeType(file: $file, path: $path)';
  }
}
