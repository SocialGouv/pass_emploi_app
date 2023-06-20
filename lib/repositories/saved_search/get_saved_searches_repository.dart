import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class GetSavedSearchRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  GetSavedSearchRepository(this._httpClient, [this._crashlytics]);

  static String getSavedSearchUrl({required String userId}) => '/jeunes/$userId/recherches';

  Future<List<SavedSearch>?> getSavedSearch(String userId) async {
    final url = getSavedSearchUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);
      final list = (response.data as List).map((search) => SavedSearchResponse.fromJson(search)).toList();
      return list.map((e) => SavedSearchJsonExtractor().extract(e)).whereType<SavedSearch>().toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
