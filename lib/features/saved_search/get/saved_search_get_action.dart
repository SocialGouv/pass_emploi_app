import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class SavedSearchGetFromIdAction {
  final String savedSearchId;

  SavedSearchGetFromIdAction(this.savedSearchId);
}

class FetchRechercheRecenteAction {
  final SavedSearch savedSearch;

  FetchRechercheRecenteAction(this.savedSearch);
}
