import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/search/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class OffreEmploiFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldDisplayDistanceFiltre;
  final bool shouldDisplayNonDistanceFiltres;
  final int initialDistanceValue;
  final bool? initialDebutantOnlyFiltre;
  final List<CheckboxValueViewModel<ContratFiltre>> contratFiltres;
  final List<CheckboxValueViewModel<DureeFiltre>> dureeFiltres;
  final String errorMessage;
  final Function(
    int? updatedDistanceValue,
    bool? debutantOnlyFiltre,
    List<CheckboxValueViewModel<ContratFiltre>>? contratFiltres,
    List<CheckboxValueViewModel<DureeFiltre>>? dureeFiltres,
  ) updateFiltres;

  OffreEmploiFiltresViewModel._({
    required this.displayState,
    required this.shouldDisplayDistanceFiltre,
    required this.shouldDisplayNonDistanceFiltres,
    required this.initialDistanceValue,
    required this.initialDebutantOnlyFiltre,
    required this.contratFiltres,
    required this.dureeFiltres,
    required this.errorMessage,
    required this.updateFiltres,
  });

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    final parametersState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    final searchResultsState = store.state.offreEmploiListState;
    return OffreEmploiFiltresViewModel._(
      displayState: _displayState(searchState, searchResultsState),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(parametersState),
      shouldDisplayNonDistanceFiltres: _shouldDisplayNonDistanceFiltres(parametersState),
      initialDistanceValue: _distance(parametersState),
      initialDebutantOnlyFiltre: _initialDebutantOnlyFiltre(parametersState),
      contratFiltres: _contrat(parametersState),
      dureeFiltres: _duree(parametersState),
      errorMessage: _errorMessage(searchState, searchResultsState),
      updateFiltres: (updatedDistanceValue, debutantOnlyFiltre, contratFiltres, dureeFiltres) {
        _dispatchUpdateFiltresAction(store, updatedDistanceValue, debutantOnlyFiltre, contratFiltres, dureeFiltres);
      },
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        shouldDisplayDistanceFiltre,
        shouldDisplayNonDistanceFiltres,
        initialDistanceValue,
        initialDebutantOnlyFiltre,
        contratFiltres,
        dureeFiltres,
      ];
}

String _errorMessage(OffreEmploiSearchState searchState, OffreEmploiListState searchResultsState) {
  return searchState is OffreEmploiSearchFailureState ? Strings.genericError : "";
}

bool? _initialDebutantOnlyFiltre(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is! OffreEmploiSearchParametersInitializedState) {
    return null;
  }
  return parametersState.filtres.debutantOnly;
}

List<CheckboxValueViewModel<DureeFiltre>> _duree(OffreEmploiSearchParametersState parametersState) {
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

List<CheckboxValueViewModel<ContratFiltre>> _contrat(OffreEmploiSearchParametersState parametersState) {
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

bool _shouldDisplayDistanceFiltre(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.location?.type == LocationType.COMMUNE;
  } else {
    return false;
  }
}

bool _shouldDisplayNonDistanceFiltres(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return !parametersState.onlyAlternance;
  }
  return true;
}

DisplayState _displayState(OffreEmploiSearchState searchState, OffreEmploiListState searchResultsState) {
  if (searchState is OffreEmploiSearchSuccessState && searchResultsState is OffreEmploiListSuccessState) {
    return DisplayState.CONTENT;
  } else if (searchState is OffreEmploiSearchLoadingState) {
    return DisplayState.LOADING;
  } else {
    return DisplayState.FAILURE;
  }
}

int _distance(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.filtres.distance ?? OffreEmploiSearchParametersFiltres.defaultDistanceValue;
  } else {
    return OffreEmploiSearchParametersFiltres.defaultDistanceValue;
  }
}

OffreEmploiSearchParametersFiltres? _appliedFiltres(OffreEmploiSearchParametersState parametersState) {
  OffreEmploiSearchParametersFiltres? filtres;
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    filtres = parametersState.filtres;
  }
  return filtres;
}

void _dispatchUpdateFiltresAction(
    Store<AppState> store,
    int? updatedDistanceValue,
    bool? debutantOnlyFiltre,
    List<CheckboxValueViewModel<ContratFiltre>>? contratFiltres,
    List<CheckboxValueViewModel<DureeFiltre>>? dureeFiltres) {
  store.dispatch(
    OffreEmploiSearchParametersUpdateFiltresRequestAction(
      OffreEmploiSearchParametersFiltres.withFiltres(
        distance: updatedDistanceValue,
        debutantOnly: debutantOnlyFiltre,
        contrat: contratFiltres?.map((e) => e.value).toList(),
        duree: dureeFiltres?.map((e) => e.value).toList(),
      ),
    ),
  );
}
