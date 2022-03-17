import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class PassEmploiCacheManager extends CacheManager {
  static const String _cacheKey = "yoloCacheKey";

  PassEmploiCacheManager()
      : super(Config(
          _cacheKey,
          stalePeriod: Duration(hours: 1),
          maxNrOfCacheObjects: 30,
        ));
}
