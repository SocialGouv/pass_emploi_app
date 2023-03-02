import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/favori.dart';

class GetFavorisRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  GetFavorisRepository(this._httpClient, [this._crashlytics]);

  static Uri getFavorisUri({required String baseUrl, required String userId}) {
    return Uri.parse('$baseUrl/jeunes/$userId/recherches');
  }

  Future<List<Favori>?> getFavoris(String userId) async {
    final url = '/jeunes/$userId/favoris';
    try {
      final response = await _httpClient.get(url);
      return (response.data as List) //
          .map((favori) => Favori.fromJson(favori))
          .whereType<Favori>()
          .toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
