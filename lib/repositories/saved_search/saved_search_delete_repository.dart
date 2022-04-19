import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SavedSearchDeleteRepository {
  final String _baseUrl;
  final Client _httpClient;

  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  SavedSearchDeleteRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  Future<bool> delete(String userId, String savedSearchId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/" + userId + "/recherches/" + savedSearchId);
    try {
      final response = await _httpClient.delete(url);
      if (response.statusCode.isValid()) {
        _cacheManager.removeRessource(CachedRessource.SAVED_SEARCH, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
