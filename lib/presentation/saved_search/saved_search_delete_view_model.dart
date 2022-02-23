import 'package:async_redux/async_redux.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/redux/states/saved_search_delete_state.dart';

import '../../redux/states/app_state.dart';

enum SavedSearchDeleteDisplayState { CONTENT, LOADING, FAILURE, SUCCESS }

class SavedSearchDeleteViewModel {
  final SavedSearchDeleteDisplayState displayState;
  final Function(String) onDeleteConfirm;

  SavedSearchDeleteViewModel({required this.displayState, required this.onDeleteConfirm});

  factory SavedSearchDeleteViewModel.create(Store<AppState> store) {
    return SavedSearchDeleteViewModel(
      displayState: _displayState(store.state.savedSearchDeleteState),
      onDeleteConfirm: (savedSearchId) => store.dispatch(SavedSearchDeleteRequestAction(savedSearchId)),
    );
  }
}

SavedSearchDeleteDisplayState _displayState(SavedSearchDeleteState state) {
  if (state is SavedSearchDeleteLoadingState) return SavedSearchDeleteDisplayState.LOADING;
  if (state is SavedSearchDeleteFailureState) return SavedSearchDeleteDisplayState.FAILURE;
  if (state is SavedSearchDeleteSuccessState) return SavedSearchDeleteDisplayState.SUCCESS;
  return SavedSearchDeleteDisplayState.CONTENT;
}
