import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_accepter_suggestion_alterte.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class SuggestionsRechercheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  SuggestionsRechercheRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getSuggestionsUrl({required String userId}) => '/jeunes/$userId/recherches/suggestions';

  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    final url = Uri.parse(_baseUrl + getSuggestionsUrl(userId: userId));
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        return response.bodyBytes.asListOf(SuggestionRecherche.fromJson);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<SavedSearch?> accepterSuggestion({
    required String userId,
    required String suggestionId,
    Location? location,
    double? rayon,
  }) async {
    final uri = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/suggestions/$suggestionId/accepter");
    try {
      final response = await _httpClient.post(
        uri,
        body: customJsonEncode(PostAccepterSuggestionAlerte(location: location, rayon: rayon)),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final savedSearch = SavedSearchJsonExtractor().extract(SavedSearchResponse.fromJson(json));
        _cacheManager.invalidateSuggestionsAndSavedSearch(baseUrl: _baseUrl, userId: userId);
        return savedSearch;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, uri);
    }
    return null;
  }

  Future<bool> refuserSuggestion({required String userId, required String suggestionId}) async {
    final uri = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/suggestions/$suggestionId/refuser");
    try {
      final response = await _httpClient.post(uri);
      if (response.statusCode.isValid()) {
        _cacheManager.invalidateSuggestionsAndSavedSearch(baseUrl: _baseUrl, userId: userId);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, uri);
    }
    return false;
  }
}

extension _CacheExt on PassEmploiCacheManager {
  void invalidateSuggestionsAndSavedSearch({required String baseUrl, required String userId}) {
    removeSuggestionsRechercheResource(userId: userId);
    removeResource(CachedResource.SAVED_SEARCH, userId);
  }
}
