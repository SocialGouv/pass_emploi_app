import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ImmersionFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final int initialDistanceValue;
  final Function(int? updatedDistanceValue) updateFiltres;

  final String errorMessage;

  ImmersionFiltresViewModel._({
    required this.displayState,
    required this.initialDistanceValue,
    required this.updateFiltres,
    required this.errorMessage,
  });

  factory ImmersionFiltresViewModel.create(Store<AppState> store) {
    final parametersState = store.state.immersionSearchParametersState;
    final searchState = store.state.immersionSearchState;
    final searchResultsState = store.state.immersionSearchResultsState;
    return ImmersionFiltresViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(parametersState),
      shouldDisplayNonDistanceFiltres: _shouldDisplayNonDistanceFiltres(parametersState),
      initialDistanceValue: _distance(parametersState),
      updateFiltres: (updatedDistanceValue, experienceFiltres, contratFiltres, dureeFiltres) {
        _dispatchUpdateFiltresAction(store, updatedDistanceValue, experienceFiltres, contratFiltres, dureeFiltres);
      },
      experienceFiltres: _experience(parametersState),
      contratFiltres: _contrat(parametersState),
      dureeFiltres: _duree(parametersState),
      errorMessage: _errorMessage(searchState, searchResultsState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        shouldDisplayDistanceFiltre,
        initialDistanceValue,
      ];
}

String _errorMessage(ImmersionSearchState searchState, ImmersionSearchResultsState searchResultsState) {
  return searchState is ImmersionSearchFailureState ? Strings.genericError : "";
}

List<CheckboxValueViewModel<DureeFiltre>> _duree(ImmersionSearchParametersState parametersState) {
  final filtres = _appliedFiltres(parametersState);
  return [
    CheckboxValueViewModel(
      label: Strings.dureeTempsPleinLabel,
      value: DureeFiltre.temps_plein,
      isInitiallyChecked: filtres?.duree?.contains(DureeFiltre.temps_plein) ?? false,
    ),
    CheckboxValueViewModel(
      label: Strings.dureeTempsPartielLabel,
      value: DureeFiltre.temps_partiel,
      isInitiallyChecked: filtres?.duree?.contains(DureeFiltre.temps_partiel) ?? false,
    ),
  ];
}

List<CheckboxValueViewModel<ContratFiltre>> _contrat(ImmersionSearchParametersState parametersState) {
  final filtres = _appliedFiltres(parametersState);
  return [
    CheckboxValueViewModel(
      label: Strings.contratCdiLabel,
      value: ContratFiltre.cdi,
      helpText: Strings.contratCdiTooltip,
      isInitiallyChecked: filtres?.contrat?.contains(ContratFiltre.cdi) ?? false,
    ),
    CheckboxValueViewModel(
      label: Strings.contratCddInterimSaisonnierLabel,
      value: ContratFiltre.cdd_interim_saisonnier,
      isInitiallyChecked: filtres?.contrat?.contains(ContratFiltre.cdd_interim_saisonnier) ?? false,
    ),
    CheckboxValueViewModel(
      label: Strings.contratAutreLabel,
      value: ContratFiltre.autre,
      helpText: Strings.contratAutreTooltip,
      isInitiallyChecked: filtres?.contrat?.contains(ContratFiltre.autre) ?? false,
    ),
  ];
}

List<CheckboxValueViewModel<ExperienceFiltre>> _experience(ImmersionSearchParametersState parametersState) {
  final filtres = _appliedFiltres(parametersState);
  return [
    CheckboxValueViewModel(
      label: Strings.experienceDeZeroAUnAnLabel,
      value: ExperienceFiltre.de_zero_a_un_an,
      isInitiallyChecked: filtres?.experience?.contains(ExperienceFiltre.de_zero_a_un_an) ?? false,
    ),
    CheckboxValueViewModel(
      label: Strings.experienceDeUnATroisAnsLabel,
      value: ExperienceFiltre.de_un_a_trois_ans,
      isInitiallyChecked: filtres?.experience?.contains(ExperienceFiltre.de_un_a_trois_ans) ?? false,
    ),
    CheckboxValueViewModel(
      label: Strings.experienceTroisAnsEtPlusLabel,
      value: ExperienceFiltre.trois_ans_et_plus,
      isInitiallyChecked: filtres?.experience?.contains(ExperienceFiltre.trois_ans_et_plus) ?? false,
    ),
  ];
}

bool _shouldDisplayDistanceFiltre(ImmersionSearchParametersState parametersState) {
  if (parametersState is ImmersionSearchParametersInitializedState) {
    return parametersState.location?.type == LocationType.COMMUNE;
  } else {
    return false;
  }
}

bool _shouldDisplayNonDistanceFiltres(ImmersionSearchParametersState parametersState) {
  if (parametersState is ImmersionSearchParametersInitializedState) {
    return !parametersState.onlyAlternance;
  }
  return true;
}

DisplayState _displayState(ImmersionSearchState searchState, ImmersionSearchResultsState searchResultsState) {
  if (searchState is ImmersionSearchSuccessState && searchResultsState is ImmersionSearchResultsDataState) {
    return DisplayState.CONTENT;
  } else if (searchState is ImmersionSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

int _distance(ImmersionSearchParametersState parametersState) {
  if (parametersState is ImmersionSearchParametersInitializedState) {
    return parametersState.filtres.distance ?? ImmersionSearchParametersFiltres.defaultDistanceValue;
  } else {
    return ImmersionSearchParametersFiltres.defaultDistanceValue;
  }
}

ImmersionSearchParametersFiltres? _appliedFiltres(ImmersionSearchParametersState parametersState) {
  ImmersionSearchParametersFiltres? filtres;
  if (parametersState is ImmersionSearchParametersInitializedState) {
    filtres = parametersState.filtres;
  }
  return filtres;
}

void _dispatchUpdateFiltresAction(
    Store<AppState> store,
    int? updatedDistanceValue,
    List<CheckboxValueViewModel<ExperienceFiltre>>? experienceFiltres,
    List<CheckboxValueViewModel<ContratFiltre>>? contratFiltres,
    List<CheckboxValueViewModel<DureeFiltre>>? dureeFiltres) {
  store.dispatch(
    ImmersionSearchUpdateFiltresAction(
      ImmersionSearchParametersFiltres.withFiltres(
        distance: updatedDistanceValue,
        experience: experienceFiltres?.map((e) => e.value).toList(),
        contrat: contratFiltres?.map((e) => e.value).toList(),
        duree: dureeFiltres?.map((e) => e.value).toList(),
      ),
    ),
  );
}
