import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/diagoriente_urls.dart';

class DiagorienteUrlsRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DiagorienteUrlsRepository(this._httpClient, [this._crashlytics]);

  Future<DiagorienteUrls?> getUrls(String userId) async {
    final url = '/jeunes/$userId/diagoriente/urls';
    try {
      final response = await _httpClient.get(url);
      return DiagorienteUrls.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
