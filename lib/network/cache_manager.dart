import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

class PassEmploiCacheManager extends CacheManager {
  static const Duration requestCacheDuration = Duration(minutes: 20);

  final String baseUrl;

  PassEmploiCacheManager({required Config config, required this.baseUrl}) : super(config);

  factory PassEmploiCacheManager.requestCache(String baseUrl) {
    return PassEmploiCacheManager(
      config: Config(
        "PassEmploiCacheKey",
        stalePeriod: requestCacheDuration,
        maxNrOfCacheObjects: 30,
      ),
      baseUrl: baseUrl,
    );
  }

  void removeResource(CachedResource resourceToRemove, String userId) {
    switch (resourceToRemove) {
      case CachedResource.FAVORIS:
        removeFile(baseUrl + GetFavorisRepository.getFavorisUrl(userId: userId));
        removeFile(baseUrl + ImmersionFavorisRepository.getFavorisIdUrl(userId: userId));
        removeFile(baseUrl + OffreEmploiFavorisRepository.getFavorisIdUrl(userId: userId));
        removeFile(baseUrl + ServiceCiviqueFavorisRepository.getFavorisIdUrl(userId: userId));
        break;
      case CachedResource.SAVED_SEARCH:
        removeFile(baseUrl + GetSavedSearchRepository.getSavedSearchUrl(userId: userId));
        break;
      case CachedResource.UPDATE_PARTAGE_ACTIVITE:
        removeFile(baseUrl + PartageActiviteRepository.getPartageActiviteUrl(userId: userId));
        break;
    }
  }

  void removeActionCommentaireResource(String actionId) {
    removeFile(baseUrl + ActionCommentaireRepository.getCommentairesUrl(actionId: actionId));
  }

  void removeSuggestionsRechercheResource({required String userId}) {
    removeFile(baseUrl + SuggestionsRechercheRepository.getSuggestionsUrl(userId: userId));
  }

  void removeDiagorienteFavorisResource({required String userId}) {
    removeFile(baseUrl + DiagorienteMetiersFavorisRepository.getUrl(userId: userId));
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
  '/milo/accueil',
  '/pole-emploi/accueil',
  '/home/actions',
  '/home/demarches',
  '/fichiers',
  '/docnums/',
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
