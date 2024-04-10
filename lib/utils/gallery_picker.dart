import 'package:image_picker/image_picker.dart';

class GalleryPicker {
  static Future<String?> pickSingleImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return pickedFile.path;
  }
}
