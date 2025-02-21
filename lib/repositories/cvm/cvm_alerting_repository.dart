import 'package:dio/dio.dart';

class CvmAlertingRepository {
  final Dio _httpClient;

  CvmAlertingRepository(this._httpClient);

  // On poste sur une route qui existe pas pour logger une erreur 404
  Future<void> traceFailure() async {
    try {
      await _httpClient.post('/app/logs/cvm/failure');
    } catch (_) {}
  }
}
