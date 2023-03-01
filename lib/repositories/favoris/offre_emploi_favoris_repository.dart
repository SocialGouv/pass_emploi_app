import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_favoris/post_offre_emploi_favori.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class OffreEmploiFavorisRepository extends FavorisRepository<OffreEmploi> {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  OffreEmploiFavorisRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static Uri getFavorisIdUri({required String baseUrl, required String userId}) {
    return Uri.parse(baseUrl + "/jeunes/$userId/favoris/offres-emploi");
  }

  static Uri getFavorisUri({required String baseUrl, required String userId}) {
    return getFavorisIdUri(baseUrl: baseUrl, userId: userId).replace(queryParameters: {"detail": "true"});
  }

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    final url = getFavorisIdUri(baseUrl: _baseUrl, userId: userId);
    try {
      final response = await _httpClient.get(url);

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
  Future<bool> postFavori(String userId, OffreEmploi favori) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/offres-emploi");
    try {
      final response = await _httpClient.post(
        url,
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
        _cacheManager.removeRessource(CachedRessource.OFFRE_EMPLOI_FAVORIS, userId, _baseUrl);
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
      final response = await _httpClient.delete(url);
      if (response.statusCode.isValid() || response.statusCode == 404) {
        _cacheManager.removeRessource(CachedRessource.OFFRE_EMPLOI_FAVORIS, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
