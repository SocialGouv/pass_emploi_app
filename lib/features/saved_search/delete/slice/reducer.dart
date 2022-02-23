import 'package:pass_emploi_app/features/saved_search/delete/slice/actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/slice/state.dart';

SavedSearchDeleteState savedSearchDeleteReducer(SavedSearchDeleteState current, dynamic action) {
  if (action is SavedSearchDeleteAction) {
    if (action is SavedSearchDeleteLoadingAction) {
      return SavedSearchDeleteLoadingState();
    }
    if (action is SavedSearchDeleteFailureAction) {
      return SavedSearchDeleteFailureState();
    }
    if (action is SavedSearchDeleteSuccessAction) {
      return SavedSearchDeleteSuccessState();
    } else {
      return SavedSearchDeleteNotInitializedState();
    }
  } else {
    return current;
  }
}
