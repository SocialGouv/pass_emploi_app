import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_favoris/post_immersion_favori.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class ImmersionFavorisRepository extends FavorisRepository<Immersion> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ImmersionFavorisRepository(this._httpClient, [this._crashlytics]);

  static String getFavorisIdUrl({required String userId}) => '/jeunes/$userId/favoris/offres-immersion';

  @override
  Future<Set<FavoriDto>?> getFavorisId(String userId) async {
    final url = getFavorisIdUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);
      final json = response.data as List;
      return json.map((favori) => FavoriDto.fromJson(favori as Map<String, dynamic>)).toSet();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  @override
  Future<bool> postFavori(String userId, Immersion favori, {bool postulated = false}) async {
    final url = "/jeunes/$userId/favoris/offres-immersion";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostImmersionFavori(
            id: favori.id,
            metier: favori.metier,
            nomEtablissement: favori.nomEtablissement,
            secteurActivite: favori.secteurActivite,
            ville: favori.ville,
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
    final url = "/jeunes/$userId/favoris/offres-immersion/$favoriId";
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
