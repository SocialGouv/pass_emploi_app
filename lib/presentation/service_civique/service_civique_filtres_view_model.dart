import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

const int defaultDistanceValueOnServiceCiviqueFiltre = 10;

class ServiceCiviqueFiltresViewModel extends Equatable {
  final DisplayState displayState;
  final bool shouldDisplayDistanceFiltre;
  final int initialDistanceValue;
  final Domaine initialDomainValue;
  final DateTime? initialStartDateValue;
  final Function(
    int? updatedDistance,
    Domaine? updatedDomain,
    DateTime? updatedStartDate,
  ) updateFiltres;

  ServiceCiviqueFiltresViewModel._({
    required this.displayState,
    required this.shouldDisplayDistanceFiltre,
    required this.initialDistanceValue,
    required this.updateFiltres,
    required this.initialDomainValue,
    required this.initialStartDateValue,
  });

  factory ServiceCiviqueFiltresViewModel.create(Store<AppState> store) {
    final state = store.state.rechercheServiceCiviqueState;
    return ServiceCiviqueFiltresViewModel._(
      displayState: _displayState(state),
      shouldDisplayDistanceFiltre: _shouldDisplayDistanceFiltre(state),
      initialDistanceValue: _distance(state),
      initialDomainValue: _domain(state),
      initialStartDateValue: _startDate(state),
      updateFiltres: (updatedDistance, updatedDomain, updatedStartDate) {
        _dispatchUpdateFiltresAction(store, updatedDistance, updatedDomain, updatedStartDate);
      },
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        shouldDisplayDistanceFiltre,
        initialDistanceValue,
        initialDomainValue,
        initialStartDateValue,
      ];
}

bool _shouldDisplayDistanceFiltre(RechercheServiceCiviqueState state) {
  final request = state.request;
  if (request == null) return false;

  final location = request.criteres.location;
  return location?.type == LocationType.COMMUNE && location?.longitude != null && location?.latitude != null;
}

DisplayState _displayState(RechercheState state) {
  return switch (state.status) {
    RechercheStatus.updateLoading => DisplayState.chargement,
    RechercheStatus.success => DisplayState.contenu,
    _ => DisplayState.erreur,
  };
}

int _distance(RechercheServiceCiviqueState state) {
  return state.request?.filtres.distance ?? defaultDistanceValueOnServiceCiviqueFiltre;
}

Domaine _domain(RechercheServiceCiviqueState state) {
  return state.request?.filtres.domain ?? Domaine.all;
}

DateTime? _startDate(RechercheServiceCiviqueState state) {
  return state.request?.filtres.startDate;
}

void _dispatchUpdateFiltresAction(
  Store<AppState> store,
  int? updatedDistanceValue,
  Domaine? updatedDomain,
  DateTime? updatedStartDate,
) {
  store.dispatch(RechercheUpdateFiltresAction(
    ServiceCiviqueFiltresRecherche(
      distance: updatedDistanceValue,
      domain: updatedDomain == Domaine.all ? null : updatedDomain,
      startDate: updatedStartDate,
    ),
  ));
}
