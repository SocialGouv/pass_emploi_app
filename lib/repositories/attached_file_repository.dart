import 'dart:io';

import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:path_provider/path_provider.dart';

class AttachedFileRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  AttachedFileRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<String?> download({required String fileId, required String fileName}) async {
    final url = Uri.parse(_baseUrl + "/fichiers/$fileId");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        return await _saveFile(fileName: fileName, fileId: fileId, response: response);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<String> _saveFile({required String fileName, required String fileId, required Response response}) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/chat/attached_files/$fileId/$fileName').create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
}
