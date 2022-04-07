import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PassEmploiCacheManager extends CacheManager {
  static const String _cacheKey = "yoloCacheKey";

  PassEmploiCacheManager()
      : super(Config(
          _cacheKey,
          stalePeriod: Duration(minutes: 20),
          maxNrOfCacheObjects: 30,
        ));

  void removeRessource(CachedRessource ressourceToRemove, String userId, String baseUrl) {
    switch (ressourceToRemove) {
      case CachedRessource.IMMERSION_FAVORIS:
        removeFile(baseUrl + "/jeunes/$userId/favoris/offres-immersion?detail=true");
        removeFile(baseUrl + "/jeunes/$userId/favoris/offres-immersion?detail=false");
        break;
      case CachedRessource.OFFRE_EMPLOI_FAVORIS:
        removeFile(baseUrl + "/jeunes/$userId/favoris/offres-emploi?detail=true");
        removeFile(baseUrl + "/jeunes/$userId/favoris/offres-emploi?detail=false");
        break;
      case CachedRessource.SERVICE_CIVIQUE_FAVORIS:
        removeFile(baseUrl + "/jeunes/$userId/favoris/services-civique?detail=false");
        removeFile(baseUrl + "/jeunes/$userId/favoris/services-civique?detail=true");
        break;
      case CachedRessource.SAVED_SEARCH:
        removeFile(baseUrl + "/jeunes/" + userId + "/recherches");
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
