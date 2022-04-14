import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class RendezvousRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  RendezvousRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/rendezvous");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List)
            .map((e) => JsonRendezvous.fromJson(e)) //
            .map((e) => e.toRendezvous()) //
            .toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
