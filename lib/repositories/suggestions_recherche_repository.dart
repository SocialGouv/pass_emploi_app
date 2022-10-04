import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/suggestion_recherche.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SuggestionsRechercheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  SuggestionsRechercheRepository(this._baseUrl, this._httpClient, this._cacheManager, [this._crashlytics]);

  static Uri getSuggestionsUri({required String baseUrl, required String userId}) {
    return Uri.parse(baseUrl + "/jeunes/$userId/recherches/suggestions");
  }

  Future<List<SuggestionRecherche>?> getSuggestions(String userId) async {
    final url = getSuggestionsUri(baseUrl: _baseUrl, userId: userId);
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

  Future<bool> accepterSuggestion({required String userId, required String suggestionId}) async {
    final url = "/jeunes/$userId/recherches/suggestions/$suggestionId/accepter";
    return _traiterSuggestion(url: url, userId: userId);
  }

  Future<bool> refuserSuggestion({required String userId, required String suggestionId}) async {
    final url = "/jeunes/$userId/recherches/suggestions/$suggestionId/refuser";
    return _traiterSuggestion(url: url, userId: userId);
  }

  Future<bool> _traiterSuggestion({required String url, required String userId}) async {
    final uri = Uri.parse(_baseUrl + url);
    try {
      final response = await _httpClient.post(uri);
      if (response.statusCode.isValid()) {
        _cacheManager.removeSuggestionsRechercheRessource(baseUrl: _baseUrl, userId: userId);
        _cacheManager.removeRessource(CachedRessource.SAVED_SEARCH, userId, _baseUrl);
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, uri);
    }
    return false;
  }
}
