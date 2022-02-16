import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_delete_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../../models/saved_search/saved_search.dart';

class SavedSearchDeleteReducer {
  AppState reduce(AppState current, SavedSearchDeleteAction action) {
    return current.copyWith(
      savedSearchesState: _reduceSavedSearchListState(current.savedSearchesState, action),
      savedSearchDeleteState: _reduceSavedSearchDeleteState(action),
    );
  }

  SavedSearchDeleteState _reduceSavedSearchDeleteState(SavedSearchDeleteAction action) {
    if (action is SavedSearchDeleteLoadingAction) return SavedSearchDeleteLoadingState();
    if (action is SavedSearchDeleteFailureAction) return SavedSearchDeleteFailureState();
    if (action is SavedSearchDeleteSuccessAction) return SavedSearchDeleteSuccessState();
    return SavedSearchDeleteNotInitializedState();
  }

  State<List<SavedSearch>> _reduceSavedSearchListState(
    State<List<SavedSearch>> current,
    SavedSearchDeleteAction action,
  ) {
    if (action is SavedSearchDeleteSuccessAction && current.isSuccess()) {
      final List<SavedSearch> savedSearches = current.getResultOrThrow();
      savedSearches.removeWhere((element) => element.getId() == action.savedSearchId);
      return State<List<SavedSearch>>.success(savedSearches);
    }
    return current;
  }
}
