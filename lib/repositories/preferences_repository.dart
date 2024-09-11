import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_preferences_request.dart';

class PreferencesRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  PreferencesRepository(this._httpClient, [this._crashlytics]);

  static String getPreferencesUrl({required String userId}) => "/jeunes/$userId/preferences";

  Future<Preferences?> getPreferences(String userId) async {
    final url = getPreferencesUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);

      return Preferences.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> updatePreferences(String userId, bool isShare) async {
    final url = getPreferencesUrl(userId: userId);
    try {
      await _httpClient.put(
        url,
        data: customJsonEncode(PutPreferencesRequest(favoris: isShare)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
