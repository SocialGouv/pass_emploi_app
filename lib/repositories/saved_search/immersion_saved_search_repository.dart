import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_immersion_saved_search.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class ImmersionSavedSearchRepository extends SavedSearchRepository<ImmersionSavedSearch> {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  ImmersionSavedSearchRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/immersions");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(
          PostImmersionSavedSearch(
            title: title,
            metier: savedSearch.metier,
            localisation: savedSearch.ville,
            codeRome: savedSearch.codeRome,
            lat: savedSearch.location?.latitude,
            lon: savedSearch.location?.longitude,
            distance: savedSearch.filtres.distance,
          ),
        ),
      );
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
