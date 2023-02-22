import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class DiagorienteRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DiagorienteRepository(this._httpClient, [this._crashlytics]);

  Future<String?> getChatBotUrl(String userId) async {
    final url = '/jeunes/$userId/diagoriente/urls';
    try {
      final response = await _httpClient.get(url);
      return response.data['urlChatbot'] as String;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
