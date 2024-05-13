import 'package:file_picker/file_picker.dart';

class FilePickerWrapper {
  static Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'odt', 'ods'],
    );
    return result?.files.single.path;
  }
}
