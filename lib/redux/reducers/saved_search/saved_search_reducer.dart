import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';

class SavedSearchReducer<T> {
  SavedSearchState<T> reduceSavedSearchState<T>(SavedSearchState<T> currentState, SavedSearchAction<T> action) {
    if (action is SavedSearchSuccessAction<T>) {
      return SavedSearchState<T>.successfullyCreated();
    } else if (action is SavedSearchFailureAction<T>) {
      return SavedSearchState<T>.notInitialized();
    } else {
      return currentState;
    }
  }
}