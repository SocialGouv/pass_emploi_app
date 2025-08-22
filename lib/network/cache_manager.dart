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
    return Uuid().v5(Namespace.url.value, CachedResource.fromUrl(resource)?.toString() ?? resource);
  }

  Future<void> removeResource(CachedResource resourceToRemove, String userId) async {
    await _delete(resourceToRemove.toString());
  }

  Future<void> removeAllFavorisResources() async {
    await _delete(CachedResource.favoris.toString());
    await _delete(CachedResource.favorisEmploi.toString());
    await _delete(CachedResource.favorisImmersion.toString());
    await _delete(CachedResource.favorisServiceCivique.toString());
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
  accueil,
  animationsCollectives,
  sessionsMiloList,
  sessionsMiloInscrit,
  sessionsMiloNonInscrit,
  favoris,
  favorisEmploi,
  favorisImmersion,
  favorisServiceCivique,
  alerte,
  preferences,
  userAction;

  static CachedResource? fromUrl(String url) {
    if (url.contains('/accueil')) return accueil;
    if (url.contains('/animations-collectives')) return animationsCollectives;
    if (url.endsWith('/favoris')) return favoris;
    if (url.endsWith('/favoris/offres-emploi')) return favorisEmploi;
    if (url.endsWith('/favoris/offres-immersion')) return favorisImmersion;
    if (url.endsWith('/favoris/services-civique')) return favorisServiceCivique;
    if (url.contains('/preferences')) return preferences;
    if (url.endsWith('/recherches')) return alerte;
    if (url.contains('/milo') && url.endsWith('sessions')) return sessionsMiloList;
    if (url.contains('/milo') && url.endsWith('sessions?filtrerEstInscrit=true')) return sessionsMiloInscrit;
    if (url.contains('/milo') && url.endsWith('sessions?filtrerEstInscrit=false')) return sessionsMiloNonInscrit;
    if (url.contains('/actions')) return userAction;
    return null;
  }
}
