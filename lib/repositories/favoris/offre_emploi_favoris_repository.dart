import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_favoris/post_offre_emploi_favori.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class OffreEmploiFavorisRepository extends FavorisRepository<OffreEmploi> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  OffreEmploiFavorisRepository(this._httpClient, [this._crashlytics]);

  static String getFavorisIdUrl({required String userId}) => '/jeunes/$userId/favoris/offres-emploi';

  @override
  Future<Set<String>?> getFavorisId(String userId) async {
    final url = getFavorisIdUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);

      final json = response.data as List;
      return json.map((favori) => favori["id"] as String).toSet();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  @override
  Future<bool> postFavori(String userId, OffreEmploi favori) async {
    final url = "/jeunes/$userId/favoris/offres-emploi";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostOffreEmploiFavori(
            favori.id,
            favori.title,
            favori.companyName,
            favori.contractType,
            favori.isAlternance,
            favori.location,
            favori.duration,
            favori.origin.name,
            favori.origin.logoUrl,
          ),
        ),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioException && e.response?.statusCode == 409) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> deleteFavori(String userId, String favoriId) async {
    final url = "/jeunes/$userId/favoris/offres-emploi/$favoriId";
    try {
      await _httpClient.delete(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
      if (e is DioException && e.response?.statusCode == 404) {
        return true;
      }
    }
    return false;
  }
}
