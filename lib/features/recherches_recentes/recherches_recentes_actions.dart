import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class RecherchesRecentesRequestAction {} //TODO: à voir si on garde ou si on fait au login ?

class RecherchesRecentesSuccessAction {
  final List<SavedSearch> recentSearches;

  RecherchesRecentesSuccessAction(this.recentSearches);
}
