import 'package:file_picker/file_picker.dart';

class FilePickerOutput {
  final String path;
  final bool isTooLarge;

  FilePickerOutput({required this.path, required this.isTooLarge});
}

class FilePickerWrapper {
  static const int maxFilesize = 5 * 1024 * 1024;
  static Future<FilePickerOutput?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'odt', 'ods'],
    );
    if (result == null) return null;
    final file = result.files.single;
    return FilePickerOutput(path: file.path!, isTooLarge: file.size > maxFilesize);
  }
}
