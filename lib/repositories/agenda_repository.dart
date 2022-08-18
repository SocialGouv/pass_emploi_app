import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class AgendaRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  AgendaRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<Agenda?> getAgenda(String userId, DateTime maintenant) async {
    final date = maintenant.toIso8601WithTimeZoneOffset();
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home/agenda?maintenant=$date");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return Agenda.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
