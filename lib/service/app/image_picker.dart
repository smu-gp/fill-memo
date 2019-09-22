import 'package:image_picker/image_picker.dart' as lib;

import '../image_model.dart';

Future<ImageResult> pickImage(ImageSource imageSource) async {
  var libSource;
  if (imageSource == ImageSource.gallery) {
    libSource = lib.ImageSource.gallery;
  } else if (imageSource == ImageSource.camera) {
    libSource = lib.ImageSource.camera;
  }
  var pickImage = await lib.ImagePicker.pickImage(source: libSource);
  if (pickImage != null) {
    return ImageResult(pickImage, pickImage.path);
  } else {
    return null;
  }
}
