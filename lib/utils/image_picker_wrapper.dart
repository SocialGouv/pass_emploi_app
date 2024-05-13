import 'package:image_picker/image_picker.dart';

class ImagePickerWrapper {
  static Future<String?> pickSingleImage() async {
    return _pickImage(ImageSource.gallery);
  }

  static Future<String?> takeSinglePicture() async {
    return _pickImage(ImageSource.camera);
  }

  static Future<String?> _pickImage(ImageSource source) async {
    return (await ImagePicker().pickImage(source: source))?.path;
  }
}
