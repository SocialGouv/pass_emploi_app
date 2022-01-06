import 'package:pass_emploi_app/redux/actions/offre_emploi_favoris_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, OffreEmploiFavorisAction action) {
  if (action is OffreEmploiFavorisIdLoadedAction) {
    var newState = OffreEmploiFavorisState.idsLoaded(action.favorisId);
    return currentState.copyWith(offreEmploiFavorisState: newState);
  } else if (action is OffreEmploiUpdateFavoriLoadingAction) {
    return _updateLoadingState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriSuccessAction) {
    return _updateSuccessState(currentState, action);
  } else if (action is OffreEmploiUpdateFavoriFailureAction) {
    return _updateFailureState(currentState, action);
  } else if (action is OffreEmploiFavorisLoadedAction) {
    return currentState.copyWith(offreEmploiFavorisState: _updateWithData(currentState, action));
  } else if (action is OffreEmploiFavorisFailureAction) {
    return currentState.copyWith(offreEmploiFavorisState: OffreEmploiFavorisState.notInitialized());
  } else {
    return currentState;
  }
}

OffreEmploiFavorisState _updateWithData(AppState currentState, OffreEmploiFavorisLoadedAction action) {
  return OffreEmploiFavorisState.withMap(action.favoris.keys.toSet(), action.favoris);
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
    final idList = favorisIdState.offreEmploiFavorisId;
    final data = favorisIdState.data;
    if (newStatus) {
      idList.add(offreId);
    } else {
      idList.remove(offreId);
      data?.remove(offreId);
    }
    return OffreEmploiFavorisState.withMap(idList, data);
  } else {
    return favorisIdState;
  }
}
