import 'package:pass_emploi_app/features/favori/ids/favori_ids_action.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';

class FavoriListReducer<T> {
  FavoriListState<T> reduceFavorisState(FavoriListState<T> currentState, dynamic action) {
    if (action is FavoriIdsLoadedAction<T>) {
      return FavoriListState<T>.idsLoaded(action.favoriIds);
    } else if (action is UpdateFavoriSuccessAction<T>) {
      if (currentState is FavoriListLoadedState<T>) {
        final ids = currentState.favoriIds;
        final data = currentState.data;
        if (action.confirmedNewStatus) {
          ids.add(action.favoriId);
        } else {
          ids.remove(action.favoriId);
          data?.remove(action.favoriId);
        }
        return FavoriListState<T>.withMap(ids, data);
      } else {
        return currentState;
      }
    } else if (action is FavoriListLoadedAction<T>) {
      return FavoriListState<T>.withMap(action.favoris.keys.toSet(), action.favoris);
    } else if (action is FavoriListFailureAction<T>) {
      return FavoriListState<T>.notInitialized();
    } else {
      return currentState;
    }
  }
}
