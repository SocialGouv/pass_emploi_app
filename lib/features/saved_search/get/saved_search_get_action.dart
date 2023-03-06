import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class FetchSavedSearchResultsFromIdAction {
  final String savedSearchId;

  FetchSavedSearchResultsFromIdAction(this.savedSearchId);
}

class FetchSavedSearchResultsAction {
  final SavedSearch savedSearch;

  FetchSavedSearchResultsAction(this.savedSearch);
}
