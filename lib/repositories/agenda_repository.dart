import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class AgendaRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  AgendaRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<Agenda?> getAgenda(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithTimeZoneOffset());
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home/agenda?maintenant=$date");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final delayedActions = int.parse(response.headers["x-nombre-actions-en-retard"] ?? "0");
        return Agenda.fromJson(json, delayedActions);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
