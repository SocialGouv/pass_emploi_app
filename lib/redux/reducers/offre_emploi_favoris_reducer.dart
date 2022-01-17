import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_update_state.dart';

AppState offreEmploiFavorisReducer(AppState currentState, OffreEmploiFavorisAction action) {
  if (action is FavorisIdLoadedAction<OffreEmploi>) {
    var newState = FavorisState<OffreEmploi>.idsLoaded(action.favorisId);
    return currentState.copyWith(offreEmploiFavorisState: newState);
  } else if (action is UpdateFavoriLoadingAction<OffreEmploi>) {
    return _updateLoadingState(currentState, action);
  } else if (action is UpdateFavoriSuccessAction<OffreEmploi>) {
    return _updateSuccessState(currentState, action);
  } else if (action is UpdateFavoriFailureAction<OffreEmploi>) {
    return _updateFailureState(currentState, action);
  } else if (action is FavorisLoadedAction<OffreEmploi>) {
    return currentState.copyWith(offreEmploiFavorisState: _updateWithData(currentState, action));
  } else if (action is FavorisFailureAction<OffreEmploi>) {
    return currentState.copyWith(offreEmploiFavorisState: FavorisState<OffreEmploi>.notInitialized());
  } else {
    return currentState;
  }
}

FavorisState<OffreEmploi> _updateWithData(AppState currentState, FavorisLoadedAction<OffreEmploi> action) {
  return FavorisState<OffreEmploi>.withMap(action.favoris.keys.toSet(), action.favoris);
}

AppState _updateFailureState(AppState currentState, UpdateFavoriFailureAction<OffreEmploi> action) {
  return currentState.copyWith(
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.favoriId,
      OffreEmploiFavorisUpdateStatus.ERROR,
    ),
  );
}

AppState _updateSuccessState(AppState currentState, UpdateFavoriSuccessAction<OffreEmploi> action) {
  return currentState.copyWith(
    offreEmploiFavorisState: _updateFavorisList(
      currentState,
      action.favoriId,
      action.confirmedNewStatus,
    ),
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.favoriId,
      OffreEmploiFavorisUpdateStatus.SUCCESS,
    ),
  );
}

AppState _updateLoadingState(AppState currentState, UpdateFavoriLoadingAction<OffreEmploi> action) {
  return currentState.copyWith(
    offreEmploiFavorisUpdateState: _updateState(
      currentState,
      action.favoriId,
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

FavorisState<OffreEmploi> _updateFavorisList(AppState currentState, String offreId, bool newStatus) {
  final favorisIdState = currentState.offreEmploiFavorisState;
  if (favorisIdState is FavorisLoadedState<OffreEmploi>) {
    final idList = favorisIdState.favorisId;
    final data = favorisIdState.data;
    if (newStatus) {
      idList.add(offreId);
    } else {
      idList.remove(offreId);
      data?.remove(offreId);
    }
    return FavorisState<OffreEmploi>.withMap(idList, data);
  } else {
    return favorisIdState;
  }
}
