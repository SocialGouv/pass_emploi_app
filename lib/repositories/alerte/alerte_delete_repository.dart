import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class AlerteDeleteRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  AlerteDeleteRepository(this._httpClient, [this._crashlytics]);

  Future<bool> delete(String userId, String alerteId) async {
    final url = "/jeunes/$userId/recherches/$alerteId";
    try {
      await _httpClient.delete(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
