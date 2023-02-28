import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class DiagorienteMetiersFavorisRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DiagorienteMetiersFavorisRepository(this._httpClient, [this._crashlytics]);

  Future<bool?> get(String userId) async {
    final url = "/jeunes/$userId/diagoriente/metiers-favoris";
    try {
      final response = await _httpClient.get(url);
      return response.data["aDesMetiersFavoris"] as bool;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
