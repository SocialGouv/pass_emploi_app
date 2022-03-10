import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/actions/immersion_actions.dart';

ImmersionSearchParametersState immersionSearchParametersState(
  ImmersionSearchParametersState current,
  dynamic action,
) {
  if (action is ImmersionListRequestAction) {
    return ImmersionSearchParametersInitializedState(
      location: action.request.location,
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
      codeRome: action.request.codeRome,
      ville: '',
      title: action.request.title,
    );
  } else if (action is ImmersionSearchUpdateFiltresAction) {
    if (current is ImmersionSearchParametersInitializedState) {
      return ImmersionSearchParametersInitializedState(
        location: current.location,
        filtres: action.updatedFiltres,
        codeRome: current.codeRome,
        ville: current.ville,
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
        ville: current.ville,
      );
    } else {
      return current;
    }
  } else if (action is ImmersionSearchWithFiltresAction) {
    return ImmersionSearchParametersInitializedState(
      location: action.request.location,
      filtres: action.filtres,
      codeRome: action.request.codeRome,
      ville: action.request.location.libelle,
    );
  } else {
    return current;
  }
}
