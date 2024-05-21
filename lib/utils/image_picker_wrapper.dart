import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

sealed class ImagePickerResult {}

class ImagePickerSuccessResult extends ImagePickerResult {
  final String path;

  ImagePickerSuccessResult({required this.path});
}

class ImagePickerEmptyResult extends ImagePickerResult {}

class ImagePickerErrorResult extends ImagePickerResult {}

class ImagePickerPermissionErrorResult extends ImagePickerResult {}

class ImagePickerWrapper {
  static Future<ImagePickerResult> pickSingleImage() async {
    return _pickImage(ImageSource.gallery);
  }

  static Future<ImagePickerResult> takeSinglePicture() async {
    return _pickImage(ImageSource.camera);
  }

  static Future<ImagePickerResult> _pickImage(ImageSource source) async {
    try {
      final result = await ImagePicker().pickImage(source: source);
      if (result?.path != null) return ImagePickerSuccessResult(path: result!.path);
      return ImagePickerEmptyResult();
    } catch (e) {
      if (e is PlatformException && (e.code == 'photo_access_denied' || e.code == 'camera_access_denied')) {
        return ImagePickerPermissionErrorResult();
      }
      return ImagePickerErrorResult();
    }
  }
}
