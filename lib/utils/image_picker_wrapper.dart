import 'package:image_picker/image_picker.dart';

class ImagePickerWrapper {
  static Future<String?> pickSingleImage() async {
    return (await ImagePicker().pickImage(source: ImageSource.gallery))?.path;
  }
}
