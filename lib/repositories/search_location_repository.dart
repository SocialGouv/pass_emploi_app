import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class SearchLocationRepository {
  final Dio _httpClient;

  final Crashlytics? _crashlytics;

  SearchLocationRepository(this._httpClient, [this._crashlytics]);

  Future<List<Location>> getLocations({required String userId, required String query, bool villesOnly = false}) async {
    final url = "/referentiels/communes-et-departements?recherche=$query&villesOnly=$villesOnly";
    try {
      final response = await _httpClient.get(url);
      return response.asListOf(Location.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return [];
  }
}
