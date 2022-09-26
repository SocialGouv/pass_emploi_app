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
    return [
      SuggestionRecherche(
        id: "1",
        type: SuggestionType.emploi,
        titre: "Cariste",
        metier: "Conduite d'engins de déplacement des charges",
        localisation: "Nord",
        dateCreation: DateTime(2022, 09, 10),
        dateMiseAJour: DateTime(2022, 09, 11),
      ),
      SuggestionRecherche(
        id: "2",
        type: SuggestionType.immersion,
        titre: "Boulanger",
        metier: "Chef boulanger",
        localisation: "Valence",
        dateCreation: DateTime(2022, 09, 18),
        dateMiseAJour: DateTime(2022, 09, 19),
      ),
    ];
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
}
