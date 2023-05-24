import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class SuppressionCompteRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  SuppressionCompteRepository(this._httpClient, [this._crashlytics]);

  Future<bool> deleteUser(String userId) async {
    final url = "/jeunes/$userId";
    try {
      await _httpClient.delete(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
