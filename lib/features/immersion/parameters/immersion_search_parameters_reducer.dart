import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_actions.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';

ImmersionSearchParametersState immersionSearchParametersState(
  ImmersionSearchParametersState current,
  dynamic action,
) {
  if (action is ImmersionListRequestAction) {
    return ImmersionSearchParametersInitializedState(
      location: action.location,
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
      codeRome: action.codeRome,
      title: action.title,
    );
  } else if (action is ImmersionSearchUpdateFiltresRequestAction) {
    if (current is ImmersionSearchParametersInitializedState) {
      return ImmersionSearchParametersInitializedState(
        location: current.location,
        filtres: action.updatedFiltres,
        codeRome: current.codeRome,
      );
    } else {
      return current;
    }
  } else if (action is ImmersionSearchWithUpdateFiltresFailureAction) {
    if (current is ImmersionSearchParametersInitializedState) {
      return ImmersionSearchParametersInitializedState(
        location: current.location,
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
        codeRome: current.codeRome,
      );
    } else {
      return current;
    }
  } else if (action is ImmersionSavedSearchRequestAction) {
    return ImmersionSearchParametersInitializedState(
      location: action.location,
      filtres: action.filtres,
      codeRome: action.codeRome,
    );
  } else {
    return current;
  }
}
