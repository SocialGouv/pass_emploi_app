import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_json_extractor.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class RecherchesRecentesRepository {
  static const recentSearchesKey = 'recent_searches';
  final FlutterSecureStorage _preferences;

  RecherchesRecentesRepository(this._preferences);

  Future<List<SavedSearch>> get() async {
    final String? recentSearchesJsonString = await _preferences.read(key: recentSearchesKey);
    if (recentSearchesJsonString == null) {
      return [];
    }
    final json = jsonDecode(recentSearchesJsonString);
    final list = (json as List).map((search) => SavedSearchResponse.fromJson(search)).toList();
    return list.map((e) => SavedSearchJsonExtractor().extract(e)).whereNotNull().toList();
  }

  Future<void> save(List<SavedSearch> savedSearches) async {
    final json = savedSearches
        .map((savedSearch) => savedSearch.toSavedSearchResponse())
        .whereNotNull()
        .map((response) => response.toJson())
        .toList();
    await _preferences.write(key: recentSearchesKey, value: jsonEncode(json));
  }
}

extension _SavedSearchExt on SavedSearch {
  SavedSearchResponse? toSavedSearchResponse() {
    final savedSearch = this;
    if (savedSearch is OffreEmploiSavedSearch) {
      return savedSearch.toSavedSearchResponse();
    }
    if (savedSearch is ImmersionSavedSearch) {
      return savedSearch.toSavedSearchResponse();
    }
    if (savedSearch is ServiceCiviqueSavedSearch) {
      return savedSearch.toSavedSearchResponse();
    }
    return null;
  }
}
