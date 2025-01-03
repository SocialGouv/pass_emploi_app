import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheServiceCiviqueContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Location? initialLocation;
  final Function(Location? location) onSearchingRequest;

  CriteresRechercheServiceCiviqueContenuViewModel({
    required this.displayState,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheServiceCiviqueContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheServiceCiviqueContenuViewModel(
      displayState: store.state.rechercheServiceCiviqueState.displayState(),
      initialLocation:
          store.state.rechercheServiceCiviqueState.request?.criteres.location ?? store.getLastLocationSelected(),
      onSearchingRequest: (location) => _onSearchingRequest(store, location),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

void _onSearchingRequest(Store<AppState> store, Location? location) {
  final previousRequest = store.state.rechercheServiceCiviqueState.request;
  final initialRecherche = previousRequest == null;
  store.dispatch(
    RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>(
      RechercheRequest(
        ServiceCiviqueCriteresRecherche(location: location),
        initialRecherche
            ? ServiceCiviqueFiltresRecherche.noFiltre()
            : _previousFiltresUpdated(previousRequest.filtres, location),
        1,
      ),
    ),
  );
}

ServiceCiviqueFiltresRecherche _previousFiltresUpdated(
  ServiceCiviqueFiltresRecherche currentFiltres,
  Location? location,
) {
  if (location == null) {
    return ServiceCiviqueFiltresRecherche(
      distance: null,
      startDate: currentFiltres.startDate,
      domain: currentFiltres.domain,
    );
  } else {
    return currentFiltres;
  }
}
