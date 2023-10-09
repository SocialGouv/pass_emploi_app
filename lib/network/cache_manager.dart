import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';

class PassEmploiCacheManager {
  static const Duration requestCacheDuration = Duration(minutes: 20);

  final CacheStore _cacheStore;
  final String _baseUrl;

  PassEmploiCacheManager(this._cacheStore, this._baseUrl);

  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {
    //TODO: quand on aura géré les legacy cache, il suffirait d'une seule ligne
    // cacheStore.delete(resourceToRemove.toString());
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
      case CachedResource.SAVED_SEARCH:
      case CachedResource.SESSIONS_MILO_LIST:
      case CachedResource.USER_ACTIONS_LIST:
        _delete(resourceToRemove.toString());
        break;
      case CachedResource.UPDATE_PARTAGE_ACTIVITE:
        _delete(_baseUrl + PartageActiviteRepository.getPartageActiviteUrl(userId: userId));
        break;
    }
  }

  Future<void> removeAllFavorisResources() async {
    _delete(CachedResource.FAVORIS.toString());
    _delete(CachedResource.FAVORIS_EMPLOI.toString());
    _delete(CachedResource.FAVORIS_IMMERSION.toString());
    _delete(CachedResource.FAVORIS_SERVICE_CIVIQUE.toString());
  }

  Future<void> removeActionCommentaireResource(String actionId) async {
    _delete(_baseUrl + ActionCommentaireRepository.getCommentairesUrl(actionId: actionId));
  }

  Future<void> removeSuggestionsRechercheResource({required String userId}) async {
    _delete(_baseUrl + SuggestionsRechercheRepository.getSuggestionsUrl(userId: userId));
  }

  Future<void> removeDiagorienteFavorisResource({required String userId}) async {
    _delete(_baseUrl + DiagorienteMetiersFavorisRepository.getUrl(userId: userId));
  }

  void emptyCache() => _cacheStore.clean();

  Future<void> _delete(String key) async => await _cacheStore.delete(key, staleOnly: true);
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
    if (url.contains('/home/agenda')) return AGENDA;
    if (url.contains('/animations-collectives')) return ANIMATIONS_COLLECTIVES;
    if (url.contains('/home/demarches')) return DEMARCHES_LIST;
    if (url.endsWith('/favoris')) return FAVORIS;
    if (url.endsWith('/favoris/offres-emploi')) return FAVORIS_EMPLOI;
    if (url.endsWith('/favoris/offres-immersion')) return FAVORIS_IMMERSION;
    if (url.endsWith('/favoris/services-civique')) return FAVORIS_SERVICE_CIVIQUE;
    if (url.contains('/rendezvous') && url.contains('FUTURS')) return RENDEZVOUS_FUTURS;
    if (url.contains('/rendezvous') && url.contains('PASSES')) return RENDEZVOUS_PASSES;
    if (url.endsWith('/recherches')) return SAVED_SEARCH;
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
