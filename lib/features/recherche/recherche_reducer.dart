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
      status: RechercheStatus.nouvelleRecherche,
      request: () => null,
      results: () => null,
      canLoadMore: false,
    );
  }
  if (action is RechercheNewAction<Result>) {
    return current.copyWith(
      status: RechercheStatus.nouvelleRecherche,
    );
  }
  if (action is RechercheRequestAction<Criteres, Filtres>) {
    return current.copyWith(
      status: RechercheStatus.loading,
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
  //TODO: c'est pas dommage de modifier ici et dans le middleware la requête ?
  // ou alors, on fait en 2 temps :
  // - SetFilterAction : uniquement dans reducer, changes le state
  // - ReloadAction : lance une recherche
  // Avantage 1 : on ne fais pas deux fois la modif.
  // Avantage 2 : pas besoin dans le middleware de se faire chier à faire un copy semi générique semi spécifique :)
  if (action is RechercheUpdateFiltres<Filtres>) {
    final newRequest = current.request?.copyWith(filtres: action.filtres);
    return current.copyWith(
      status: RechercheStatus.loading,
      request: () => newRequest,
    );
  }
  if (action is RechercheLoadMoreAction<Result>) {
    return current.copyWith(
      status: RechercheStatus.loading,
    );
  }
  if (action is RechercheFailureAction<Result>) return current.copyWith(status: RechercheStatus.failure);
  return current;
}
