import 'package:http/http.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiFavorisRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;

  OffreEmploiFavorisRepository(this._baseUrl, this._httpClient, this._headersBuilder);

  Future<List<String>?> getOffreEmploiFavorisId(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());

      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes) as List;
        return json.map((favori) => favori["id"] as String).toList();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }

  Future<bool> updateOffreEmploiFavoriStatus(String userId, String offreId, bool newStatus) async {
    return false;
  }
}
