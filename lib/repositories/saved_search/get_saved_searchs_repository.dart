import 'package:http/http.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

import '../../crashlytics/crashlytics.dart';
import '../../models/saved_search/saved_search.dart';
import '../../network/headers.dart';
import '../../network/json_utf8_decoder.dart';

class GetSavedSearchRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  GetSavedSearchRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<List<SavedSearch>?> getSavedSearch(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/" + userId + "/recherches");
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
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

class SavedSearchJsonExtractor {
  dynamic extract(SavedSearchResponse savedSearch) {
    if (savedSearch.type == "OFFRES_IMMERSION") {
      return SavedSearchImmersionExtractor().extract(savedSearch);
    } else if (savedSearch.type == "OFFRES_EMPLOI" || savedSearch.type == "OFFRES_ALTERNANCE") {
      return SavedSearchEmploiExtractor().extract(savedSearch);
    } else {
      return null;
    }
  }
}
