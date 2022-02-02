import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_favoris/post_offre_emploi_favori.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class OffreEmploiFavorisRepository extends FavorisRepository<OffreEmploi> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  OffreEmploiFavorisRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/offres-emploi");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());

      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes) as List;
        return json.map((favori) => favori["id"] as String).toSet();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  @override
  Future<Map<String, OffreEmploi>?> getFavoris(String userId) async {
    final url =
        Uri.parse(_baseUrl + "/jeunes/$userId/favoris/offres-emploi").replace(queryParameters: {"detail": "true"});
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
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi favori) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/offres-emploi");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(contentType: 'application/json'),
        body: customJsonEncode(
          PostOffreEmploiFavori(
            favori.id,
            favori.title,
            favori.companyName,
            favori.contractType,
            favori.isAlternance,
            favori.location,
            favori.duration,
          ),
        ),
      );
      if (response.statusCode.isValid() || response.statusCode == 409) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String favoriId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/offres-emploi/$favoriId");
    try {
      final response = await _httpClient.delete(
        url,
        headers: await _headersBuilder.headers(),
      );
      if (response.statusCode.isValid() || response.statusCode == 404) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
