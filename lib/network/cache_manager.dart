import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

class PassEmploiCacheManager extends CacheManager {
  static const Duration requestCacheDuration = Duration(minutes: 20);

  PassEmploiCacheManager(Config config) : super(config);

  factory PassEmploiCacheManager.requestCache() {
    return PassEmploiCacheManager(Config(
      "PassEmploiCacheKey",
      stalePeriod: requestCacheDuration,
      maxNrOfCacheObjects: 30,
    ));
  }

  void removeResource(CachedResource resourceToRemove, String userId, String baseUrl) {
    switch (resourceToRemove) {
      case CachedResource.FAVORIS:
        removeFile(GetFavorisRepository.getFavorisUri(baseUrl: baseUrl, userId: userId).toString());
        break;
      case CachedResource.SAVED_SEARCH:
        removeFile(GetSavedSearchRepository.getSavedSearchUri(baseUrl: baseUrl, userId: userId).toString());
        break;
      case CachedResource.UPDATE_PARTAGE_ACTIVITE:
        removeFile(PartageActiviteRepository.getPartageActiviteUri(baseUrl: baseUrl, userId: userId).toString());
        break;
    }
  }

  void removeActionCommentaireResource(String actionId, String baseUrl) {
    removeFile(ActionCommentaireRepository.getCommentairesUri(baseUrl: baseUrl, actionId: actionId).toString());
  }

  void removeSuggestionsRechercheResource({required String baseUrl, required String userId}) {
    removeFile(SuggestionsRechercheRepository.getSuggestionsUri(baseUrl: baseUrl, userId: userId).toString());
  }
}

enum CachedResource {
  FAVORIS,
  SAVED_SEARCH,
  UPDATE_PARTAGE_ACTIVITE,
}

const _blacklistedRoutes = [
  '/rendezvous',
  '/home/agenda',
  '/home/agenda/pole-emploi',
  '/home/actions',
  '/home/demarches',
  '/fichiers',
  'diagoriente/metiers-favoris',
];

extension Whiteliste on String {
  bool isWhitelistedForCache() {
    for (final route in _blacklistedRoutes) {
      if (contains(route)) return false;
    }
    return true;
  }
}

bool isCacheStillUpToDate(FileInfo file) {
  // The lib set a default value to 7-days cache when there isn't cache-control headers in our HTTP responses.
  // And our backend do not set these headers.
  // In future : directly use `getSingleFile` without checking date.
  const defaultCacheDuration = Duration(days: 7);
  final now = DateTime.now().add(defaultCacheDuration).subtract(PassEmploiCacheManager.requestCacheDuration);
  return file.validTill.isAfter(now);
}
