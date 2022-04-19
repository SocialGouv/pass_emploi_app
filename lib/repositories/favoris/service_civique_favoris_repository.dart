import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';

class ServiceCiviqueFavorisRepository extends FavorisRepository<ServiceCivique> {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  ServiceCiviqueFavorisRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static Uri getFavorisIdUri({required String baseUrl, required String userId}) {
    return Uri.parse(baseUrl + "/jeunes/$userId/favoris/services-civique");
  }

  static Uri getFavorisUri({required String baseUrl, required String userId}) {
    return getFavorisIdUri(baseUrl: baseUrl, userId: userId).replace(queryParameters: {"detail": "true"});
  }

  @override
  Future<bool> deleteFavori(String userId, String favoriId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/services-civique/$favoriId");
    try {
      final response = await _httpClient.delete(url);
      if (response.statusCode.isValid() || response.statusCode == 404) {
        _cacheManager.removeRessource(CachedRessource.SERVICE_CIVIQUE_FAVORIS, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }

  @override
  Future<Map<String, ServiceCivique>?> getFavoris(String userId) async {
    final url = getFavorisUri(baseUrl: _baseUrl, userId: userId);
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes) as List;
        return {for (var element in json) element["id"] as String: ServiceCivique.fromJson(element)};
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
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
  Future<bool> postFavori(String userId, ServiceCivique favori) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/favoris/services-civique");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(
          PostServiceCiviqueFavori(
              id: favori.id,
              title: favori.title,
              domain: favori.domain!,
              organisation: favori.companyName,
              ville: favori.location,
              dateDeDebut: favori.startDate),
        ),
      );
      if (response.statusCode.isValid() || response.statusCode == 409) {
        _cacheManager.removeRessource(CachedRessource.SERVICE_CIVIQUE_FAVORIS, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
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
