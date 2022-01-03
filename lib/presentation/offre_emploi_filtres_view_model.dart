import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class OffreEmploiFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldDisplayDistanceFiltre;
  final int initialDistanceValue;
  final Function(
    int? updatedDistanceValue,
    List<CheckboxValueViewModel<ExperienceFiltre>>? experienceFiltres,
    List<CheckboxValueViewModel<ContratFiltre>>? contratFiltres,
    List<CheckboxValueViewModel<DureeFiltre>>? dureeFiltres,
  ) updateFiltres;

  final List<CheckboxValueViewModel<ExperienceFiltre>> experienceFiltres;
  final List<CheckboxValueViewModel<ContratFiltre>> contratFiltres;
  final List<CheckboxValueViewModel<DureeFiltre>> dureeFiltres;

  OffreEmploiFiltresViewModel._({
    required this.displayState,
    required this.shouldDisplayDistanceFiltre,
    required this.initialDistanceValue,
    required this.updateFiltres,
    required this.experienceFiltres,
    required this.contratFiltres,
    required this.dureeFiltres,
  });

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    final parametersState = store.state.offreEmploiSearchParametersState;
    final searchState = store.state.offreEmploiSearchState;
    return OffreEmploiFiltresViewModel._(
      displayState: _displayState(searchState),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(parametersState),
      initialDistanceValue: _distance(parametersState),
      updateFiltres: (
        updatedDistanceValue,
        experienceFiltres,
        contratFiltres,
        dureeFiltres,
      ) {
        return store.dispatch(
          OffreEmploiSearchUpdateFiltresAction(
            OffreEmploiSearchParametersFiltres.withFiltres(
              distance: updatedDistanceValue,
              experience: experienceFiltres?.map((e) => e.value).toList(),
              contrat: contratFiltres?.map((e) => e.value).toList(),
              duree: dureeFiltres?.map((e) => e.value).toList(),
            ),
          ),
        );
      },
      experienceFiltres: _experience(parametersState),
      contratFiltres: _contrat(parametersState),
      dureeFiltres: _duree(parametersState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        shouldDisplayDistanceFiltre,
        initialDistanceValue,
      ];
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
      isInitiallyChecked: filtres?.contrat?.contains(ContratFiltre.autre) ?? false,
    ),
  ];
}

List<CheckboxValueViewModel<ExperienceFiltre>> _experience(OffreEmploiSearchParametersState parametersState) {
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

bool _shouldDisplayDistanceFiltre(OffreEmploiSearchParametersState parametersState) {
  if (parametersState is OffreEmploiSearchParametersInitializedState) {
    return parametersState.location?.type == LocationType.COMMUNE;
  } else {
    return false;
  }
}

DisplayState _displayState(OffreEmploiSearchState searchState) {
  if (searchState is OffreEmploiSearchSuccessState) {
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
