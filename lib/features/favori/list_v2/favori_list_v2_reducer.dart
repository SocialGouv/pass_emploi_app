import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';
import 'package:pass_emploi_app/features/favori/update/favori_update_actions.dart';
import 'package:pass_emploi_app/models/favori.dart';

FavoriListV2State favoriListV2Reducer(FavoriListV2State current, dynamic action) {
  if (action is FavoriListV2RequestAction) return FavoriListV2LoadingState();
  if (action is FavoriListV2FailureAction) return FavoriListV2FailureState();
  if (action is FavoriListV2SuccessAction) return FavoriListV2SuccessState(action.results);
  if (action is FavoriListV2ResetAction) return FavoriListV2NotInitializedState();
  if (_favoriIsRemoved(current, action)) return _successStateWithoutRemovedFavori(current, action);
  return current;
}

bool _favoriIsRemoved(FavoriListV2State current, dynamic action) {
  return action is FavoriUpdateRequestAction && action.newStatus == false;
}

FavoriListV2State _successStateWithoutRemovedFavori(FavoriListV2State current, dynamic action) {
  if (current is FavoriListV2SuccessState) {
    final results = List<Favori>.from(current.results);
    results.removeWhere((favori) => favori.id == action.favoriId);
    return FavoriListV2SuccessState(results);
  }
  return current;
}
