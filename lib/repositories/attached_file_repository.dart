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

  Future<String?> download({required String fileId, required String fileExtension}) async {
    final url = Uri.parse(_baseUrl + "/fichiers/$fileId");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final tempDir = await getTemporaryDirectory();
        final file = await  File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(response.bodyBytes);
        return file.path;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}