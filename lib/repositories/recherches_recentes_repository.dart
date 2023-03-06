import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class RecherchesRecentesRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  RecherchesRecentesRepository(this._httpClient, [this._crashlytics]);

  Future<List<SavedSearch>?> get() async {
    const url = "/jeunes/todo";
    try {
      final response = await _httpClient.get(url);
      return [];
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
