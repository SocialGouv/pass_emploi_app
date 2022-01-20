import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/repositories/favoris_repository.dart';

class ImmersionFavorisRepository extends FavorisRepository<Immersion> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  ImmersionFavorisRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  @override
  Future<bool> deleteFavori(String userId, String favoriId) {
    // TODO: implement deleteFavori
    throw UnimplementedError();
  }

  @override
  Future<Map<String, Immersion>?> getFavoris(String userId) {
    // TODO: implement getFavoris
    throw UnimplementedError();
  }

  @override
  Future<Set<String>?> getFavorisId(String userId) {
    // TODO: implement getFavorisId
    throw UnimplementedError();
  }

  @override
  Future<bool> postFavori(String userId, Immersion favori) {
    // TODO: implement postFavori
    throw UnimplementedError();
  }
}
