import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SearchLocationRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  SearchLocationRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<Location>> getLocations({required String userId, required String query, bool villesOnly = false}) async {
    final url = Uri.parse(_baseUrl + "/referentiels/communes-et-departements?recherche=$query&villesOnly=$villesOnly");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((location) => Location.fromJson(location)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return [];
  }
}
