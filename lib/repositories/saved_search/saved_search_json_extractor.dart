import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_response.dart';

class SavedSearchJsonExtractor {
  SavedSearch? extract(SavedSearchResponse savedSearch) {
    if (savedSearch.type == "OFFRES_IMMERSION") {
      return SavedSearchImmersionExtractor().extract(savedSearch);
    } else if (savedSearch.type == "OFFRES_SERVICES_CIVIQUE") {
      return SavedSearchServiceCiviqueExtractor().extract(savedSearch);
    } else if (savedSearch.type == "OFFRES_EMPLOI" || savedSearch.type == "OFFRES_ALTERNANCE") {
      return SavedSearchEmploiExtractor().extract(savedSearch);
    } else {
      return null;
    }
  }
}
