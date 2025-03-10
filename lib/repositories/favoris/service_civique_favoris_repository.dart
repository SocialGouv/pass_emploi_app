import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class ServiceCiviqueFavorisRepository extends FavorisRepository<ServiceCivique> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ServiceCiviqueFavorisRepository(this._httpClient, [this._crashlytics]);

  static String getFavorisIdUrl({required String userId}) => '/jeunes/$userId/favoris/services-civique';

  @override
  Future<bool> deleteFavori(String userId, String favoriId) async {
    final url = '/jeunes/$userId/favoris/services-civique/$favoriId';
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
  Future<bool> postFavori(String userId, ServiceCivique favori, {bool postulated = false}) async {
    final url = "/jeunes/$userId/favoris/services-civique";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostServiceCiviqueFavori(
              id: favori.id,
              title: favori.title,
              domain: favori.domain!,
              organisation: favori.companyName,
              ville: favori.location,
              dateDeDebut: favori.startDate),
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
}

class PostServiceCiviqueFavori implements JsonSerializable {
  final String id;
  final String title;
  final String domain;
  final String? organisation;
  final String? dateDeDebut;
  final String? ville;

  PostServiceCiviqueFavori({
    required this.id,
    required this.title,
    required this.domain,
    required this.organisation,
    required this.dateDeDebut,
    required this.ville,
  });

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": title,
        "domaine": domain,
        "ville": ville,
        "dateDeDebut": dateDeDebut,
        "organisation": organisation,
      };
}
