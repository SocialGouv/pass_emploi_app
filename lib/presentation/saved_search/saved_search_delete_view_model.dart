import 'package:pass_emploi_app/features/saved_search/delete/actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

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
