import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class AccueilRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  AccueilRepository(this._httpClient, [this._crashlytics]);

  Future<Accueil?> getAccueilMissionLocale(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithOffsetDateTime());
    final url = "/jeunes/$userId/milo/accueil?maintenant=$date";
    try {
      final response = await _httpClient.get(url);
      return Accueil.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
