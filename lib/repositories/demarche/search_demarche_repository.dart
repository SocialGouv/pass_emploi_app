import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SearchDemarcheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  SearchDemarcheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<DemarcheDuReferentiel>?> search(String query) async {
    final url = Uri.parse(_baseUrl + '/referentiels/pole-emploi/types-demarches?recherche=$query');
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((demarche) => DemarcheDuReferentiel.fromJson(demarche)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
