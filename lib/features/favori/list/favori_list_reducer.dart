import 'package:pass_emploi_app/features/favori/list/favori_list_actions.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';

FavoriListState favoriListReducer(FavoriListState current, dynamic action) {
  if (action is FavoriListRequestAction) return FavoriListLoadingState();
  if (action is FavoriListFailureAction) return FavoriListFailureState();
  if (action is FavoriListSuccessAction) return FavoriListSuccessState(action.results);
  if (action is FavoriListResetAction) return FavoriListNotInitializedState();
  if (_favoriIsRemoved(current, action)) return _successStateWithoutRemovedFavori(current, action);
  return current;
}

bool _favoriIsRemoved(FavoriListState current, dynamic action) {
  return action is FavoriUpdateRequestAction && action.newStatus == FavoriStatus.removed;
}

FavoriListState _successStateWithoutRemovedFavori(FavoriListState current, dynamic action) {
  if (current is FavoriListSuccessState) {
    final results = List<Favori>.from(current.results);
    results.removeWhere((favori) => favori.id == action.favoriId);
    return FavoriListSuccessState(results);
  }
  return current;
}
