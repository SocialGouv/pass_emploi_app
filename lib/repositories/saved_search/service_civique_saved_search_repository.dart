import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_service_civique_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class ServiceCiviqueSavedSearchRepository extends SavedSearchRepository<ServiceCiviqueSavedSearch> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;
  final PassEmploiCacheManager _cacheManager;

  ServiceCiviqueSavedSearchRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, ServiceCiviqueSavedSearch savedSearch, String title) async {
    final url = "/jeunes/$userId/recherches/services-civique";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostServiceCiviqueSavedSearch(
            titre: title,
            localisation: savedSearch.ville,
            lat: savedSearch.location?.latitude,
            lon: savedSearch.location?.longitude,
            distance: savedSearch.filtres.distance,
            dateDeDebutMinimum: savedSearch.dateDeDebut?.toIso8601String(),
            domaine: savedSearch.domaine?.tag,
          ),
        ),
      );
      _cacheManager.removeResource(CachedResource.SAVED_SEARCH, userId);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
