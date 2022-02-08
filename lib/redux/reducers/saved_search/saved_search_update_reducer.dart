import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/saved_search_update_state.dart';

class SavedSearchUpdateReducer {
  SavedSearchUpdateState reduceUpdateState<T>(SavedSearchUpdateState currentState, SavedSearchAction<T> action) {
  //   if (action is UpdateFavoriLoadingAction<T>) {
  //     return _updateState(
  //       currentState,
  //       action.favoriId,
  //       SavedSearchUpdateStatus.LOADING,
  //     );
  //   } else if (action is UpdateFavoriSuccessAction<T>) {
  //     return _updateState(
  //       currentState,
  //       action.favoriId,
  //       SavedSearchUpdateStatus.SUCCESS,
  //     );
  //   } else if (action is UpdateFavoriFailureAction<T>) {
  //     return _updateState(
  //       currentState,
  //       action.favoriId,
  //       SavedSearchUpdateStatus.ERROR,
  //     );
  //   } else {
      return currentState;
    // }
  }

  SavedSearchUpdateState _updateState(
      SavedSearchUpdateState currentState,
      String offreId,
      SavedSearchUpdateStatus status,
      ) {
    final newStatusMap = Map.of(currentState.requestStatus);
    newStatusMap[offreId] = status;
    return SavedSearchUpdateState(newStatusMap);
  }
}