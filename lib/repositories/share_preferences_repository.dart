import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/share_preferences.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/put_share_preferences_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SharePreferencesRepository {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  SharePreferencesRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static Uri getSharePreferencesUri({required String baseUrl, required String userId}) {
    return Uri.parse(baseUrl + "/jeunes/" + userId + "/preferences");
  }

  Future<SharePreferences?> getSharePreferences(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/preferences");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return SharePreferences.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<bool> updateSharePreferences(String userId, bool isShare) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/preferences");
    try {
      final response = await _httpClient.put(
        url,
        body: customJsonEncode(PutSharePreferencesRequest(favoris: isShare)),
      );
      if (response.statusCode.isValid()) {
        _cacheManager.removeRessource(CachedRessource.UPDATE_SHARE_PREFERENCES, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}