import 'package:image_picker/image_picker.dart';

class PhotoServices {
  static double maxSize = 1920;

  static Future<XFile?> pickSingleImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: maxSize,
      maxHeight: maxSize,
    );
    if (pickedFile == null) return null;
    return XFile(pickedFile.path);
  }
}
