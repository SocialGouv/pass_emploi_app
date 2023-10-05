import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class SavedSearchDeleteRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  SavedSearchDeleteRepository(this._httpClient, [this._crashlytics]);

  Future<bool> delete(String userId, String savedSearchId) async {
    final url = "/jeunes/" + userId + "/recherches/" + savedSearchId;
    try {
      await _httpClient.delete(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
