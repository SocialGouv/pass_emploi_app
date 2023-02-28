import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';

FavoriListV2State favoriListV2Reducer(FavoriListV2State current, dynamic action) {
  if (action is FavoriListV2RequestAction) return FavoriListV2LoadingState();
  if (action is FavoriListV2FailureAction) return FavoriListV2FailureState();
  if (action is FavoriListV2SuccessAction) return FavoriListV2SuccessState(action.results);
  if (action is FavoriListV2ResetAction) return FavoriListV2NotInitializedState();
  return current;
}
