import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/put_partage_activite_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class PartageActiviteRepository {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  PartageActiviteRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getPartageActiviteUrl({required String userId}) => "/jeunes/$userId/preferences";

  Future<PartageActivite?> getPartageActivite(String userId) async {
    final url = Uri.parse(_baseUrl + getPartageActiviteUrl(userId: userId));
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return PartageActivite.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<bool> updatePartageActivite(String userId, bool isShare) async {
    final url = Uri.parse(_baseUrl + getPartageActiviteUrl(userId: userId));
    try {
      final response = await _httpClient.put(
        url,
        body: customJsonEncode(PutPartageActiviteRequest(favoris: isShare)),
      );
      if (response.statusCode.isValid()) {
        _cacheManager.removeResource(CachedResource.UPDATE_PARTAGE_ACTIVITE, userId);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
