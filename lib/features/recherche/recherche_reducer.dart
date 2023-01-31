import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';

RechercheState<Request, Result> rechercheReducer<Request, Result>(
  RechercheState<Request, Result> current,
  dynamic action,
) {
  if (action is RechercheResetAction) {
    return current.copyWith(
      status: RechercheStatus.newSearch,
      request: null,
      results: null,
      canLoadMore: false,
    );
  }
  if (action is RechercheRequestAction<Request>) {
    return current.copyWith(
      status: RechercheStatus.loading,
      request: () => action.request,
    );
  }
  if (action is RechercheSuccessAction<Result>) {
    return current.copyWith(
      status: RechercheStatus.newSearch,
      results: () => action.results,
      canLoadMore: action.canLoadMore,
    );
  }
  if (action is RechercheFailureAction) return current.copyWith(status: RechercheStatus.failure);
  return current;
}
