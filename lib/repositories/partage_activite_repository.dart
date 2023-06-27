import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/partage_activite.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_partage_activite_request.dart';

class PartageActiviteRepository {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  PartageActiviteRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getPartageActiviteUrl({required String userId}) => "/jeunes/$userId/preferences";

  Future<PartageActivite?> getPartageActivite(String userId) async {
    final url = getPartageActiviteUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);

      return PartageActivite.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> updatePartageActivite(String userId, bool isShare) async {
    final url = getPartageActiviteUrl(userId: userId);
    try {
      await _httpClient.put(
        url,
        data: customJsonEncode(PutPartageActiviteRequest(favoris: isShare)),
      );
      _cacheManager.removeResource(CachedResource.UPDATE_PARTAGE_ACTIVITE, userId);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
