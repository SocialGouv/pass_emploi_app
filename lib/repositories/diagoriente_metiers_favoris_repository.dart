import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/metier.dart';

class DiagorienteMetiersFavorisRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DiagorienteMetiersFavorisRepository(this._httpClient, [this._crashlytics]);

  Future<List<Metier>?> get(String userId) async {
    final url = "/jeunes/$userId/diagoriente/metiers-favoris";
    try {
      final response = await _httpClient.get(url);
      final metiers = response.data["metiersFavoris"];
      return (metiers as List).map(Metier.fromJson).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
