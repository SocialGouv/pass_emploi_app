import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_immersion_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class ImmersionSavedSearchRepository extends SavedSearchRepository<ImmersionSavedSearch> {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  ImmersionSavedSearchRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, ImmersionSavedSearch savedSearch, String title) async {
    final url = "/jeunes/$userId/recherches/immersions";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostImmersionSavedSearch(
            title: title,
            metier: savedSearch.metier,
            localisation: savedSearch.ville,
            codeRome: savedSearch.codeRome,
            lat: savedSearch.location.latitude,
            lon: savedSearch.location.longitude,
            distance: savedSearch.filtres.distance,
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
