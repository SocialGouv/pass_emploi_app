import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class CvmTokenRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  CvmTokenRepository(this._httpClient, [this._crashlytics]);

  Future<String?> getToken(String userId) async {
    final url = "/jeunes/$userId/pole-emploi/idp-token";
    try {
      final response = await _httpClient.get(url);
      return response.data as String;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack);
    }
    return null;
  }
}
