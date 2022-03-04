import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';

SavedSearchCreateState<T> savedSearchCreateReducer<T>(SavedSearchCreateState<T> current, dynamic action) {
  if (action is SavedSearchCreateLoadingAction<T>) return SavedSearchCreateState<T>.loading();
  if (action is SavedSearchCreateFailureAction<T>) return SavedSearchCreateState<T>.failure();
  if (action is SavedSearchCreateInitializeAction<T>) return SavedSearchCreateState<T>.initialized(action.savedSearch);
  if (action is SavedSearchCreateSuccessAction<T>) return SavedSearchCreateState<T>.successfullyCreated();
  if (action is SavedSearchCreateResetAction<T>) return SavedSearchCreateState<T>.notInitialized();
  return current;
}
