import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_id_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploisFavorisIdLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisIdState: OffreEmploiFavorisIdState.idsLoaded(action.favorisId));
  } else if (action is OffreEmploiUpdateFavoriLoadingAction) {
    return _updateLoadingState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriSuccessAction) {
    return _updateSuccessState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriFailureAction) {
    return _updateFailureState(currentState, action);
  } else {
    return currentState;
  }
}

AppState _updateFailureState(AppState currentState, OffreEmploiUpdateFavoriFailureAction action) {
  return currentState.copyWith(
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.offreId,
      OffreEmploiFavorisUpdateStatus.ERROR,
    ),
  );
}

AppState _updateSuccessState(AppState currentState, OffreEmploiUpdateFavoriSuccessAction action) {
  return currentState.copyWith(
    offreEmploiFavorisIdState: _updateFavorisList(
      currentState,
      action.offreId,
      action.confirmedNewStatus,
    ),
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.offreId,
      OffreEmploiFavorisUpdateStatus.SUCCESS,
    ),
  );
}

AppState _updateLoadingState(AppState currentState, OffreEmploiUpdateFavoriLoadingAction action) {
  return currentState.copyWith(
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.offreId,
      OffreEmploiFavorisUpdateStatus.LOADING,
    ),
  );
}

OffreEmploiFavorisUpdateState _updateState(
    AppState currentState, String offreId, OffreEmploiFavorisUpdateStatus status) {
  final currentUpdateState = currentState.offreEmploiFavorisUpdateState;
  final newStatusMap = Map.of(currentUpdateState.requestStatus);
  newStatusMap[offreId] = status;
  return OffreEmploiFavorisUpdateState(newStatusMap);
}

OffreEmploiFavorisIdState _updateFavorisList(AppState currentState, String offreId, bool newStatus) {
  final favorisIdState = currentState.offreEmploiFavorisIdState;
  if (favorisIdState is OffreEmploiFavorisIdLoadedState) {
    final oldList = favorisIdState.offreEmploiFavorisListId;
    if (newStatus) {
      oldList.add(offreId);
    } else {
      oldList.remove(offreId);
    }
    return OffreEmploiFavorisIdLoadedState(oldList);
  } else {
    return favorisIdState;
  }
}
