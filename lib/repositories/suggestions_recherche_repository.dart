import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_accepter_suggestion_alerte.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class SuggestionsRechercheRepository {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  SuggestionsRechercheRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getSuggestionsUrl({required String userId}) =>
      '/jeunes/$userId/recherches/suggestions?avecDiagoriente=true';

  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    final url = getSuggestionsUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);
      final suggestions = response.asListOf(SuggestionRecherche.fromJson);
      final validSuggestions = _suggestionsSanitized(suggestions);
      return validSuggestions;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<SavedSearch?> accepterSuggestion({
    required String userId,
    required String suggestionId,
    Location? location,
    double? rayon,
  }) async {
    final uri = "/jeunes/$userId/recherches/suggestions/$suggestionId/accepter";
    try {
      final response = location != null && rayon != null
          ? await _httpClient.post(
              uri,
              data: customJsonEncode(PostAccepterSuggestionAlerte(location: location, rayon: rayon)),
            )
          : await _httpClient.post(uri);

      final savedSearch = SavedSearchJsonExtractor().extract(SavedSearchResponse.fromJson(response.data));
      _cacheManager.invalidateSuggestionsAndSavedSearch(userId: userId);
      return savedSearch;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, uri);
    }
    return null;
  }

  Future<bool> refuserSuggestion({required String userId, required String suggestionId}) async {
    final uri = "/jeunes/$userId/recherches/suggestions/$suggestionId/refuser";
    try {
      await _httpClient.post(uri);
      _cacheManager.invalidateSuggestionsAndSavedSearch(userId: userId);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, uri);
    }
    return false;
  }

  List<SuggestionRecherche> _suggestionsSanitized(List<SuggestionRecherche> suggestions) {
    return List<SuggestionRecherche>.from(suggestions.whereNot((suggestion) =>
        suggestion.source == SuggestionSource.diagoriente &&
        switch (suggestion.type) {
          OffreType.emploi => false,
          OffreType.immersion => false,
          _ => true,
        }));
  }
}

extension _CacheExt on PassEmploiCacheManager {
  void invalidateSuggestionsAndSavedSearch({required String userId}) {
    removeSuggestionsRechercheResource(userId: userId);
    removeResource(CachedResource.SAVED_SEARCH, userId);
  }
}
