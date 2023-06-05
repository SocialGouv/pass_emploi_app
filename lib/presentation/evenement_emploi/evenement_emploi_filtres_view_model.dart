import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class EvenementEmploiFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final List<CheckboxValueViewModel<EvenementEmploiType?>> typeFiltres;
  final List<CheckboxValueViewModel<EvenementEmploiModalite>> modalitesFiltres;
  final DateTime? initialDateDebut;
  final DateTime? initialDateFin;

  EvenementEmploiFiltresViewModel._({
    required this.displayState,
    required this.typeFiltres,
    required this.modalitesFiltres,
    required this.initialDateDebut,
    required this.initialDateFin,
  });

  factory EvenementEmploiFiltresViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEvenementEmploiState;
    final filtres = state.request?.filtres;
    return EvenementEmploiFiltresViewModel._(
      displayState: _displayState(state),
      typeFiltres: _typeFiltres(filtres),
      modalitesFiltres: _modalitesFiltres(filtres),
      initialDateDebut: filtres?.dateDebut,
      initialDateFin: filtres?.dateFin,
    );
  }

  @override
  List<Object?> get props => [displayState, typeFiltres, modalitesFiltres, initialDateDebut, initialDateFin];
}

DisplayState _displayState(RechercheState state) {
  return switch (state.status) {
    RechercheStatus.updateLoading => DisplayState.LOADING,
    RechercheStatus.success => DisplayState.CONTENT,
    _ => DisplayState.FAILURE,
  };
}

List<CheckboxValueViewModel<EvenementEmploiType?>> _typeFiltres(EvenementEmploiFiltresRecherche? filtres) {
  return [
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeAll,
      value: null,
      isInitiallyChecked: filtres?.type == null,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeReunionInformation,
      value: EvenementEmploiType.reunionInformation,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.reunionInformation,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeForum,
      value: EvenementEmploiType.forum,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.forum,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeConference,
      value: EvenementEmploiType.conference,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.conference,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeAtelier,
      value: EvenementEmploiType.atelier,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.atelier,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeSalonEnLigne,
      value: EvenementEmploiType.salonEnLigne,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.salonEnLigne,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeJobDating,
      value: EvenementEmploiType.jobDating,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.jobDating,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypeVisiteEntreprise,
      value: EvenementEmploiType.visiteEntreprise,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.visiteEntreprise,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiTypePortesOuvertes,
      value: EvenementEmploiType.portesOuvertes,
      isInitiallyChecked: filtres?.type == EvenementEmploiType.portesOuvertes,
    ),
  ];
}

List<CheckboxValueViewModel<EvenementEmploiModalite>> _modalitesFiltres(EvenementEmploiFiltresRecherche? filtres) {
  return [
    CheckboxValueViewModel(
      label: Strings.evenementEmploiModaliteEnPhysique,
      value: EvenementEmploiModalite.enPhysique,
      isInitiallyChecked: filtres?.modalites?.contains(EvenementEmploiModalite.enPhysique) == true,
    ),
    CheckboxValueViewModel(
      label: Strings.evenementEmploiModaliteADistance,
      value: EvenementEmploiModalite.aDistance,
      isInitiallyChecked: filtres?.modalites?.contains(EvenementEmploiModalite.aDistance) == true,
    ),
  ];
}
