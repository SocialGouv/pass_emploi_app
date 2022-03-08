import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_state.dart';

class FavorisUpdateReducer {
  FavorisUpdateState reduceUpdateState<T>(FavorisUpdateState currentState, FavorisAction<T> action) {
    if (action is UpdateFavoriLoadingAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        FavorisUpdateStatus.LOADING,
      );
    } else if (action is UpdateFavoriSuccessAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        FavorisUpdateStatus.SUCCESS,
      );
    } else if (action is UpdateFavoriFailureAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        FavorisUpdateStatus.ERROR,
      );
    } else {
      return currentState;
    }
  }

  FavorisUpdateState _updateState(
    FavorisUpdateState currentState,
    String offreId,
    FavorisUpdateStatus status,
  ) {
    final newStatusMap = Map.of(currentState.requestStatus);
    newStatusMap[offreId] = status;
    return FavorisUpdateState(newStatusMap);
  }
}
