import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';

class PassEmploiCacheManager extends CacheManager {
  static const String _cacheKey = "PassEmploiCacheKey";

  PassEmploiCacheManager()
      : super(Config(
          _cacheKey,
          stalePeriod: Duration(minutes: 20),
          maxNrOfCacheObjects: 30,
        ));

  void removeRessource(CachedRessource ressourceToRemove, String userId, String baseUrl) {
    switch (ressourceToRemove) {
      case CachedRessource.IMMERSION_FAVORIS:
        removeFile(ImmersionFavorisRepository.getFavorisUri(baseUrl: baseUrl, userId: userId).toString());
        removeFile(ImmersionFavorisRepository.getFavorisIdUri(baseUrl: baseUrl, userId: userId).toString());
        break;
      case CachedRessource.OFFRE_EMPLOI_FAVORIS:
        removeFile(OffreEmploiFavorisRepository.getFavorisUri(baseUrl: baseUrl, userId: userId).toString());
        removeFile(OffreEmploiFavorisRepository.getFavorisIdUri(baseUrl: baseUrl, userId: userId).toString());
        break;
      case CachedRessource.SERVICE_CIVIQUE_FAVORIS:
        removeFile(ServiceCiviqueFavorisRepository.getFavorisUri(baseUrl: baseUrl, userId: userId).toString());
        removeFile(ServiceCiviqueFavorisRepository.getFavorisIdUri(baseUrl: baseUrl, userId: userId).toString());
        break;
      case CachedRessource.SAVED_SEARCH:
        removeFile(GetSavedSearchRepository.getSavedSearchUri(baseUrl: baseUrl, userId: userId).toString());
        break;
    }
  }
}

enum CachedRessource {
  IMMERSION_FAVORIS,
  OFFRE_EMPLOI_FAVORIS,
  SERVICE_CIVIQUE_FAVORIS,
  SAVED_SEARCH,
}
