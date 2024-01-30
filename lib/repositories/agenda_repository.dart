import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class AgendaRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  AgendaRepository(this._httpClient, [this._crashlytics]);

  Future<Agenda?> getAgendaPoleEmploi(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithOffsetDateTime());
    final url = "/v2/jeunes/$userId/home/agenda/pole-emploi?maintenant=$date";
    try {
      final response = await _httpClient.get(url);
      return Agenda.fromV2Json(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
