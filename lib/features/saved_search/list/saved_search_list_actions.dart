import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class SavedSearchListRequestAction {}

class SavedSearchListLoadingAction {}

class SavedSearchListSuccessAction {
  final List<SavedSearch> savedSearches;

  SavedSearchListSuccessAction(this.savedSearches);
}

class SavedSearchListFailureAction {}

class SavedSearchListResetAction {}
