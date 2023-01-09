import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class RendezvousRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  RendezvousRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<RendezvousListResult?> getRendezvousList(String userId, RendezvousPeriod period) async {
    final periodParam = period == RendezvousPeriod.PASSE ? "PASSES" : "FUTURS";
    final url =
        Uri.parse(_baseUrl + "/v2/jeunes/$userId/rendezvous").replace(queryParameters: {"periode": periodParam});

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return RendezvousListResult(
          rendezvous: (json["resultat"] as List)
              .map((e) => JsonRendezvous.fromJson(e)) //
              .map((e) => e.toRendezvous()) //
              .toList(),
          dateDerniereMiseAJour: (json["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone(),
        );
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<Rendezvous?> getRendezvous(String userId, String rendezvousId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/rendezvous/$rendezvousId");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return JsonRendezvous.fromJson(json).toRendezvous();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
