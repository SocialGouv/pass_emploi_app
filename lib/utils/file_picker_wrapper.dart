import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

sealed class FilePickerResult {}

class FilePickerSuccessResult extends FilePickerResult {
  final String path;
  final bool isTooLarge;

  FilePickerSuccessResult({required this.path, required this.isTooLarge});
}

class FilePickerEmptyResult extends FilePickerResult {}

class FilePickerErrorResult extends FilePickerResult {}

class FilePickerPermissionErrorResult extends FilePickerResult {}

class FilePickerWrapper {
  static const int maxFilesize = 5 * 1024 * 1024;
  static Future<FilePickerResult> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'odt', 'ods'],
      );
      if (result == null) return FilePickerEmptyResult();
      final file = result.files.single;
      return FilePickerSuccessResult(path: file.path!, isTooLarge: file.size > maxFilesize);
    } catch (e) {
      if (e is PlatformException && e.code == "read_external_storage_denied") {
        return FilePickerPermissionErrorResult();
      }
    }
    return FilePickerErrorResult();
  }
}
