import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class EventListRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  EventListRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<Rendezvous>?> get(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithOffsetDateTime());
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/animations-collectives?maintenant=$date");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        return response.bodyBytes.asListOf((json) => JsonRendezvous.fromJson(json).toRendezvous());
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
