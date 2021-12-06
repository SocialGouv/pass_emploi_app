import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_id_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, dynamic action) {
  if (action is OffreEmploisFavorisIdLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisState: OffreEmploiFavorisState.withoutData(action.favorisId));
  } else if (action is OffreEmploiUpdateFavoriLoadingAction) {
    return _updateLoadingState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriSuccessAction) {
    return _updateSuccessState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriFailureAction) {
    return _updateFailureState(currentState, action);
  } else if (action is OffreEmploisFavorisLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisState: _updateWithData(currentState, action));
  } else {
    return currentState;
  }
}

OffreEmploiFavorisState _updateWithData(AppState currentState, OffreEmploisFavorisLoadedAction action) {
  final favorisIdState = currentState.offreEmploiFavorisState;
  if (favorisIdState is OffreEmploiFavorisLoadedState) {
    return OffreEmploiFavorisState.withMap(action.favoris);
  } else {
    return favorisIdState;
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
    offreEmploiFavorisState: _updateFavorisList(
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

OffreEmploiFavorisState _updateFavorisList(AppState currentState, String offreId, bool newStatus) {
  final favorisIdState = currentState.offreEmploiFavorisState;
  if (favorisIdState is OffreEmploiFavorisLoadedState) {
    final oldList = favorisIdState.offreEmploiFavoris;
    if (newStatus) {
      oldList[offreId] = null;
    } else {
      oldList.remove(offreId);
    }
    return OffreEmploiFavorisState.withMap(oldList);
  } else {
    return favorisIdState;
  }
}
