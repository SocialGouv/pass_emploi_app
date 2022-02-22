import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';

class FavorisReducer<T> {
  FavorisState<T> reduceFavorisState(FavorisState<T> currentState, FavorisAction<T> action) {
    if (action is FavorisIdLoadedAction<T>) {
      return FavorisState<T>.idsLoaded(action.favorisId);
    } else if (action is UpdateFavoriSuccessAction<T>) {
      if (currentState is FavorisLoadedState<T>) {
        final idList = currentState.favorisId;
        final data = currentState.data;
        if (action.confirmedNewStatus) {
          idList.add(action.favoriId);
        } else {
          idList.remove(action.favoriId);
          data?.remove(action.favoriId);
        }
        return FavorisState<T>.withMap(idList, data);
      } else {
        return currentState;
      }
    } else if (action is FavorisLoadedAction<T>) {
      return FavorisState<T>.withMap(action.favoris.keys.toSet(), action.favoris);
    } else if (action is FavorisFailureAction<T>) {
      return FavorisState<T>.notInitialized();
    } else {
      return currentState;
    }
  }
}
