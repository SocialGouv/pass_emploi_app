import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';

RechercheState<Criteres, Filtres, Result>
    rechercheReducer<Criteres extends Equatable, Filtres extends Equatable, Result extends Equatable>(
  RechercheState<Criteres, Filtres, Result> current,
  dynamic action,
) {
  if (action is RechercheResetAction<Result>) return RechercheState.initial();
  if (action is RechercheRequestAction<Criteres, Filtres>) {
    return current.copyWith(
      status: RechercheStatus.initialLoading,
      request: () => action.request,
    );
  }
  if (action is RechercheSuccessAction<Criteres, Filtres, Result>) {
    return current.copyWith(
      status: RechercheStatus.success,
      request: () => action.request,
      results: () => action.results,
      canLoadMore: action.canLoadMore,
    );
  }
  if (action is RechercheOpenCriteresAction<Result>) return current.copyWith(status: RechercheStatus.nouvelleRecherche);
  if (action is RechercheCloseCriteresAction<Result>) {
    return current.copyWith(
      status: current.results != null ? RechercheStatus.success : RechercheStatus.nouvelleRecherche);
  }
  if (action is RechercheUpdateFiltresAction<Filtres>) return current.copyWith(status: RechercheStatus.updateLoading);
  if (action is RechercheLoadMoreAction<Result>) return current.copyWith(status: RechercheStatus.updateLoading);
  if (action is RechercheFailureAction<Result>) return current.copyWith(status: RechercheStatus.failure);
  return current;
}
