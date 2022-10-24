import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class MetierRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  MetierRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<Metier>> getMetiers(String userInput) async {
    if (userInput.length < 2) return [];

    final url = Uri.parse(_baseUrl + "/referentiels/metiers?recherche=$userInput");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        return response.bodyBytes.asListOf(Metier.fromJson);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return [];
  }
}
