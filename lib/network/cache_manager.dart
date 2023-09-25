import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
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

  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {
    //TODO: quand on aura géré les legacy cache, il suffirait d'une seule ligne
    // removeFile(resourceToRemove.toString());
    switch (resourceToRemove) {
      case CachedResource.ACCUEIL:
      case CachedResource.AGENDA:
      case CachedResource.ANIMATIONS_COLLECTIVES:
      case CachedResource.DEMARCHES_LIST:
      case CachedResource.FAVORIS:
      case CachedResource.FAVORIS_EMPLOI:
      case CachedResource.FAVORIS_IMMERSION:
      case CachedResource.FAVORIS_SERVICE_CIVIQUE:
      case CachedResource.RENDEZVOUS_FUTURS:
      case CachedResource.RENDEZVOUS_PASSES:
      case CachedResource.USER_ACTIONS_LIST:
      case CachedResource.SESSIONS_MILO_LIST:
        await removeFile(resourceToRemove.toString());
        break;
      case CachedResource.SAVED_SEARCH:
        await removeFile(baseUrl + GetSavedSearchRepository.getSavedSearchUrl(userId: userId));
        break;
      case CachedResource.UPDATE_PARTAGE_ACTIVITE:
        await removeFile(baseUrl + PartageActiviteRepository.getPartageActiviteUrl(userId: userId));
        break;
    }
  }

  Future<void> removeAllFavorisResources() async {
    await removeFile(CachedResource.FAVORIS.toString());
    await removeFile(CachedResource.FAVORIS_EMPLOI.toString());
    await removeFile(CachedResource.FAVORIS_IMMERSION.toString());
    await removeFile(CachedResource.FAVORIS_SERVICE_CIVIQUE.toString());
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
  ACCUEIL,
  AGENDA,
  ANIMATIONS_COLLECTIVES,
  DEMARCHES_LIST,
  RENDEZVOUS_FUTURS,
  RENDEZVOUS_PASSES,
  SESSIONS_MILO_LIST,
  USER_ACTIONS_LIST,
  FAVORIS,
  FAVORIS_EMPLOI,
  FAVORIS_IMMERSION,
  FAVORIS_SERVICE_CIVIQUE,
  SAVED_SEARCH,
  UPDATE_PARTAGE_ACTIVITE;

  static CachedResource? fromUrl(String url) {
    //TODO: est-ce qu'on a envie de dupliquer avec l'adresse en dur dans le repo ?
    // ou est-ce qu'on ferait un truc du genre url contains Repo.getUri().path (le path sans query selon les urls pour éviter les dates)
    // Risque de la duplication : l'url change dans le repo mais pas ici, le cache devient KO
    if (url.contains('/accueil')) return ACCUEIL;
    if (url.contains('/home/demarches')) return DEMARCHES_LIST;
    if (url.endsWith('/favoris')) return FAVORIS;
    if (url.endsWith('/favoris/offres-emploi')) return FAVORIS_EMPLOI;
    if (url.endsWith('/favoris/offres-immersion')) return FAVORIS_IMMERSION;
    if (url.endsWith('/favoris/services-civique')) return FAVORIS_SERVICE_CIVIQUE;
    if (url.contains('/home/agenda')) return AGENDA;
    if (url.contains('/animations-collectives')) return ANIMATIONS_COLLECTIVES;
    if (url.contains('/rendezvous') && url.contains('FUTURS')) return RENDEZVOUS_FUTURS;
    if (url.contains('/rendezvous') && url.contains('PASSES')) return RENDEZVOUS_PASSES;
    if (url.contains('/milo') && url.contains('sessions') && !url.contains('sessions/')) return SESSIONS_MILO_LIST;
    if (url.contains('/home/actions')) return USER_ACTIONS_LIST;
    return null;
  }
}

//TODO: à garder ?
const _blacklistedRoutes = [
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
