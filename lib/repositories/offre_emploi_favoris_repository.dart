import 'package:http/http.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_offre_emploi_favori.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiFavorisRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;

  OffreEmploiFavorisRepository(this._baseUrl, this._httpClient, this._headersBuilder);

  Future<Set<String>?> getOffreEmploiFavorisId(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());

      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes) as List;
        return json.map((favori) => favori["id"] as String).toSet();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }

  Future<Map<String, OffreEmploi>?> getOffreEmploiFavoris(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris").replace(queryParameters: {"detail": "true"});
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes) as List;
        return Map.fromIterable(
          json,
          key: (element) => element["id"],
          value: (element) => OffreEmploi.fromJson(element),
        );
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }

  Future<bool> postFavori(String userId, OffreEmploi offre) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favori");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(contentType: 'application/json'),
        body: customJsonEncode(
          PostOffreEmploiFavori(
            offre.id,
            offre.title,
            offre.companyName,
            offre.contractType,
            offre.location,
            offre.duration,
          ),
        ),
      );
      if (response.statusCode.isValid() || response.statusCode == 409) {
        return true;
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return false;
  }

  Future<bool> deleteFavori(String userId, String offreId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favori/$offreId");
    try {
      final response = await _httpClient.delete(
        url,
        headers: await _headersBuilder.headers(),
      );
      if (response.statusCode.isValid() || response.statusCode == 404) {
        return true;
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return false;
  }
}
