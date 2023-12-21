import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
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
  final List<CheckboxValueViewModel<EvenementEmploiModalite>> modalitesFiltres;
  final EvenementEmploiType? initialTypeValue;
  final DateTime? initialDateDebut;
  final DateTime? initialDateFin;
  final Function(
    EvenementEmploiType? type,
    List<CheckboxValueViewModel<EvenementEmploiModalite>>? modalitesFiltres,
    DateTime? dateDebut,
    DateTime? dateFin,
  ) updateFiltres;

  EvenementEmploiFiltresViewModel._({
    required this.displayState,
    required this.modalitesFiltres,
    required this.initialTypeValue,
    required this.initialDateDebut,
    required this.initialDateFin,
    required this.updateFiltres,
  });

  factory EvenementEmploiFiltresViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheEvenementEmploiState;
    final filtres = state.request?.filtres;
    return EvenementEmploiFiltresViewModel._(
      displayState: _displayState(state),
      modalitesFiltres: _modalitesFiltres(filtres),
      initialTypeValue: filtres?.type,
      initialDateDebut: filtres?.dateDebut,
      initialDateFin: filtres?.dateFin,
      updateFiltres: (updatedModalitesFiltres, updatedType, updatedDateDebut, updatedDateFin) {
        _dispatchUpdateFiltresAction(store, updatedModalitesFiltres, updatedType, updatedDateDebut, updatedDateFin);
      },
    );
  }

  @override
  List<Object?> get props => [displayState, modalitesFiltres, initialDateDebut, initialDateFin];
}

DisplayState _displayState(RechercheState state) {
  return switch (state.status) {
    RechercheStatus.updateLoading => DisplayState.chargement,
    RechercheStatus.success => DisplayState.contenu,
    _ => DisplayState.erreur,
  };
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

void _dispatchUpdateFiltresAction(
  Store<AppState> store,
  EvenementEmploiType? updatedType,
  List<CheckboxValueViewModel<EvenementEmploiModalite>>? modalitesFiltres,
  DateTime? updatedDateDebut,
  DateTime? updatedDateFin,
) {
  store.dispatch(
    RechercheUpdateFiltresAction<EvenementEmploiFiltresRecherche>(
      EvenementEmploiFiltresRecherche.withFiltres(
        type: updatedType,
        modalites: modalitesFiltres?.map((e) => e.value).toList(),
        dateDebut: updatedDateDebut,
        dateFin: updatedDateFin,
      ),
    ),
  );
}
