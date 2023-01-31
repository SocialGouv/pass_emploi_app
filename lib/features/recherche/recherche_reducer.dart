import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';

RechercheState<Criteres, Filtres, Result>
    rechercheReducer<Criteres extends Equatable, Filtres extends Equatable, Result extends Equatable>(
  RechercheState<Criteres, Filtres, Result> current,
  dynamic action,
) {
  if (action is RechercheResetAction<Result>) {
    return current.copyWith(
      status: RechercheStatus.newSearch,
      request: null,
      results: null,
      canLoadMore: false,
    );
  }
  if (action is RechercheNewAction<Result>) {
    return current.copyWith(
      status: RechercheStatus.newSearch,
    );
  }
  if (action is RechercheRequestAction<Criteres, Filtres>) {
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
  if (action is RechercheFailureAction<Result>) return current.copyWith(status: RechercheStatus.failure);
  return current;
}
