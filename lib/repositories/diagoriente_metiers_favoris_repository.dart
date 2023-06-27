import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

class DiagorienteMetiersFavorisRepository {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  DiagorienteMetiersFavorisRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getUrl({required String userId}) {
    return "/jeunes/$userId/diagoriente/metiers-favoris";
  }

  Future<List<Metier>?> get(String userId, bool forceNoCache) async {
    final url = getUrl(userId: userId);

    if (forceNoCache) {
      _cacheManager.removeDiagorienteFavorisResource( userId: userId);
    }

    try {
      final response = await _httpClient.get(url);
      final metiers = response.data["metiersFavoris"];
      return (metiers as List).map(Metier.fromJson).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
