import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_actions.dart';

ImmersionListState immersionListReducer(ImmersionListState current, dynamic action) {
  if (action is ImmersionListLoadingAction) return ImmersionListLoadingState();
  if (action is ImmersionListFailureAction) return ImmersionListFailureState();
  if (action is ImmersionListSuccessAction) return ImmersionListSuccessState(action.immersions);
  if (action is ImmersionSearchWithUpdateFiltresSuccessAction) return ImmersionListSuccessState(action.immersions);
  if (action is ImmersionSearchWithUpdateFiltresFailureAction) return ImmersionListFailureState();
  if (action is ImmersionListResetAction) return ImmersionListNotInitializedState();
  return current;
}
