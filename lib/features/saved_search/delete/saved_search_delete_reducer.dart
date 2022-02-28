import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_state.dart';

SavedSearchDeleteState savedSearchDeleteReducer(SavedSearchDeleteState current, dynamic action) {
  if (action is SavedSearchDeleteLoadingAction) return SavedSearchDeleteLoadingState();
  if (action is SavedSearchDeleteFailureAction) return SavedSearchDeleteFailureState();
  if (action is SavedSearchDeleteSuccessAction) return SavedSearchDeleteSuccessState();
  if (action is SavedSearchDeleteResetAction) return SavedSearchDeleteNotInitializedState();
  return current;
}
