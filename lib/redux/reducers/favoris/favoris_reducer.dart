import 'package:pass_emploi_app/features/favori/ids/favori_ids_action.dart';
import 'package:pass_emploi_app/redux/actions/favoris_action.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';

class FavorisReducer<T> {
  FavorisState<T> reduceFavorisState(FavorisState<T> currentState, dynamic action) {
    if (action is FavoriIdsLoadedAction<T>) {
      return FavorisState<T>.idsLoaded(action.favoriIds);
    } else if (action is UpdateFavoriSuccessAction<T>) {
      if (currentState is FavorisLoadedState<T>) {
        final ids = currentState.favoriIds;
        final data = currentState.data;
        if (action.confirmedNewStatus) {
          ids.add(action.favoriId);
        } else {
          ids.remove(action.favoriId);
          data?.remove(action.favoriId);
        }
        return FavorisState<T>.withMap(ids, data);
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
