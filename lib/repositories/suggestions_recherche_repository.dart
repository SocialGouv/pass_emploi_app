import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SuggestionsRechercheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  SuggestionsRechercheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/suggestions");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        return response.bodyBytes.asListOf(SuggestionRecherche.fromJson);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/suggestions/$suggestionId/creer-recherche");
    try {
      final response = await _httpClient.post(url);
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
