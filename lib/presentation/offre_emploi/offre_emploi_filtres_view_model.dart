import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
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
    required this.updateFiltres,
  });

  factory OffreEmploiFiltresViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEmploiState;
    final criteres = state.request?.criteres;
    final filtres = state.request?.filtres;
    return OffreEmploiFiltresViewModel._(
      displayState: _displayState(state),
      shouldDisplayDistanceFiltre: criteres?.location?.type == LocationType.COMMUNE,
      shouldDisplayNonDistanceFiltres: criteres != null ? !criteres.rechercheType.isOnlyAlternance() : true,
      initialDistanceValue: filtres?.distance ?? EmploiFiltresRecherche.defaultDistanceValue,
      initialDebutantOnlyFiltre: filtres?.debutantOnly,
      contratFiltres: _contrat(filtres),
      dureeFiltres: _duree(filtres),
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

List<CheckboxValueViewModel<DureeFiltre>> _duree(EmploiFiltresRecherche? filtres) {
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

List<CheckboxValueViewModel<ContratFiltre>> _contrat(EmploiFiltresRecherche? filtres) {
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

DisplayState _displayState(RechercheState state) {
  return switch (state.status) {
    RechercheStatus.updateLoading => DisplayState.chargement,
    RechercheStatus.success => DisplayState.contenu,
    _ => DisplayState.erreur,
  };
}

void _dispatchUpdateFiltresAction(
    Store<AppState> store,
    int? updatedDistanceValue,
    bool? debutantOnlyFiltre,
    List<CheckboxValueViewModel<ContratFiltre>>? contratFiltres,
    List<CheckboxValueViewModel<DureeFiltre>>? dureeFiltres) {
  store.dispatch(
    RechercheUpdateFiltresAction<EmploiFiltresRecherche>(
      EmploiFiltresRecherche.withFiltres(
        distance: updatedDistanceValue,
        debutantOnly: debutantOnlyFiltre,
        contrat: contratFiltres?.map((e) => e.value).toList(),
        duree: dureeFiltres?.map((e) => e.value).toList(),
      ),
    ),
  );
}
