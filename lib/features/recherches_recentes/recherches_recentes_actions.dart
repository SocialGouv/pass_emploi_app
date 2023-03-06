import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class RecherchesRecentesRequestAction {}

class RecherchesRecentesLoadingAction {}

class RecherchesRecentesSuccessAction {
  final List<SavedSearch> recentSearches;

  RecherchesRecentesSuccessAction(this.recentSearches);
}

class RecherchesRecentesFailureAction {}

class RecherchesRecentesResetAction {}
