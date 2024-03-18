import 'package:dio/dio.dart';

class CvmAlertingRepository {
  final Dio _httpClient;

  CvmAlertingRepository(this._httpClient);

  Future<void> traceFailure() async {
    try {
      await _httpClient.post('/app/logs/cvm/failure');
    } catch (_) {}
  }
}
