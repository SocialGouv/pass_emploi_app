import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class OffreEmploiSavedSearchRepository extends SavedSearchRepository<OffreEmploiSavedSearch> {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  OffreEmploiSavedSearchRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch, String title) async {
    final url = "/jeunes/$userId/recherches/offres-emploi";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostOffreEmploiSavedSearch(
            title: title,
            metier: savedSearch.metier,
            localisation: savedSearch.location,
            keywords: savedSearch.keyword,
            isAlternance: savedSearch.onlyAlternance,
            debutantOnly: savedSearch.filters.debutantOnly,
            experience: savedSearch.filters.experience,
            contrat: savedSearch.filters.contrat,
            duration: savedSearch.filters.duree,
            rayon: savedSearch.filters.distance,
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
