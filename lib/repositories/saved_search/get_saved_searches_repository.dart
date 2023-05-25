import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class GetSavedSearchRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  GetSavedSearchRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  static String getSavedSearchUrl({required String userId}) => '/jeunes/$userId/recherches';

  Future<List<SavedSearch>?> getSavedSearch(String userId) async {
    final url = Uri.parse(_baseUrl + getSavedSearchUrl(userId: userId));
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json as List).map((search) => SavedSearchResponse.fromJson(search)).toList();
        return list.map((e) => SavedSearchJsonExtractor().extract(e)).whereType<SavedSearch>().toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
