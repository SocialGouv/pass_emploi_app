import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';

class FavorisUpdateReducer {
  OffreEmploiFavorisUpdateState reduceUpdateState<T>(
      OffreEmploiFavorisUpdateState currentState, FavorisAction<T> action) {
    if (action is UpdateFavoriLoadingAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        OffreEmploiFavorisUpdateStatus.LOADING,
      );
    } else if (action is UpdateFavoriSuccessAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        OffreEmploiFavorisUpdateStatus.SUCCESS,
      );
    } else if (action is UpdateFavoriFailureAction<T>) {
      return _updateState(
        currentState,
        action.favoriId,
        OffreEmploiFavorisUpdateStatus.ERROR,
      );
    } else {
      return currentState;
    }
  }

  OffreEmploiFavorisUpdateState _updateState(
    OffreEmploiFavorisUpdateState currentState,
    String offreId,
    OffreEmploiFavorisUpdateStatus status,
  ) {
    final newStatusMap = Map.of(currentState.requestStatus);
    newStatusMap[offreId] = status;
    return OffreEmploiFavorisUpdateState(newStatusMap);
  }
}
