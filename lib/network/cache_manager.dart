import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/suggestions_recherche_repository.dart';
import 'package:uuid/uuid.dart';

class PassEmploiCacheManager {
  static const Duration requestCacheDuration = Duration(minutes: 20);

  final CacheStore _cacheStore;
  final String _baseUrl;

  PassEmploiCacheManager(this._cacheStore, this._baseUrl);

  /// Required to encode resource to be compatible with file path (i.e. no special characters ":", "/", etc.)
  static String getCacheKey(String resource) {
    return Uuid().v5(Uuid.NAMESPACE_URL, CachedResource.fromUrl(resource)?.toString() ?? resource);
  }

  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {
    await _delete(resourceToRemove.toString());
  }

  Future<void> removeAllFavorisResources() async {
    await _delete(CachedResource.FAVORIS.toString());
    await _delete(CachedResource.FAVORIS_EMPLOI.toString());
    await _delete(CachedResource.FAVORIS_IMMERSION.toString());
    await _delete(CachedResource.FAVORIS_SERVICE_CIVIQUE.toString());
  }

  Future<void> removeActionCommentaireResource(String actionId) async {
    await _delete(_baseUrl + ActionCommentaireRepository.getCommentairesUrl(actionId: actionId));
  }

  Future<void> removeSuggestionsRechercheResource({required String userId}) async {
    await _delete(_baseUrl + SuggestionsRechercheRepository.getSuggestionsUrl(userId: userId));
  }

  Future<void> removeDiagorienteFavorisResource({required String userId}) async {
    await _delete(_baseUrl + DiagorienteMetiersFavorisRepository.getUrl(userId: userId));
  }

  void emptyCache() => _cacheStore.clean();

  Future<void> _delete(String key) async => await _cacheStore.delete(getCacheKey(key), staleOnly: false);
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
    if (url.contains('/preferences')) return UPDATE_PARTAGE_ACTIVITE;
    if (url.contains('/rendezvous') && url.contains('FUTURS')) return RENDEZVOUS_FUTURS;
    if (url.contains('/rendezvous') && url.contains('PASSES')) return RENDEZVOUS_PASSES;
    if (url.endsWith('/recherches')) return SAVED_SEARCH;
    if (url.contains('/milo') && url.contains('sessions') && !url.contains('sessions/')) return SESSIONS_MILO_LIST;
    if (url.contains('/home/actions')) return USER_ACTIONS_LIST;
    return null;
  }
}
