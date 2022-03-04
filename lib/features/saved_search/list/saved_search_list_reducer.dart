import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

SavedSearchListState savedSearchListReducer(SavedSearchListState current, dynamic action) {
  if (action is SavedSearchListLoadingAction) return SavedSearchListLoadingState();
  if (action is SavedSearchListFailureAction) return SavedSearchListFailureState();
  if (action is SavedSearchListSuccessAction) return SavedSearchListSuccessState(action.savedSearches);
  if (action is SavedSearchListResetAction) return SavedSearchListNotInitializedState();
  if (action is SavedSearchDeleteSuccessAction && current is SavedSearchListSuccessState) {
    final List<SavedSearch> savedSearches = current.savedSearches;
    savedSearches.removeWhere((element) => element.getId() == action.savedSearchId);
    return SavedSearchListSuccessState(savedSearches);
  }
  return current;
}
