import 'package:pass_emploi_app/redux/actions/immersion_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_state.dart';

AppState immersionSearchReducer(AppState currentState, ImmersionSearchAction action) {
  if (action is ImmersionSearchLoadingAction) {
    return currentState.copyWith(immersionSearchState: ImmersionSearchState.loading());
  } else if (action is ImmersionSearchSuccessAction) {
    return currentState.copyWith(immersionSearchState: ImmersionSearchState.success(action.immersions));
  } else if (action is ImmersionSearchFailureAction) {
    return currentState.copyWith(immersionSearchState: ImmersionSearchState.failure());
  } else if (action is ImmersionSearchResetResultsAction) {
    return currentState.copyWith(immersionSearchState: ImmersionSearchState.notInitialized());
  } else {
    return currentState;
  }
}
