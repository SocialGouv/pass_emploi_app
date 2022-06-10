import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/status_code.dart';

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
        // todo utiliser un cache avec la bonne expiration et injecter dans constructeur
        final cache = PassEmploiCacheManager(Config("aaa"));
        final file = await cache.putFile(url.toString(), response.bodyBytes, fileExtension: fileExtension);
        return file.path;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
