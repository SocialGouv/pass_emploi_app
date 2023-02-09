import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheServiceCiviqueContenuViewModel extends Equatable {
  final DisplayState displayState;
  final List<LocationViewModel> locations;
  final Function(String? input) onInputLocation;
  final Function(Location? location) onSearchingRequest;

  CriteresRechercheServiceCiviqueContenuViewModel({
    required this.displayState,
    required this.locations,
    required this.onInputLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheServiceCiviqueContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheServiceCiviqueContenuViewModel(
      displayState: _displayState(store),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input)),
      onSearchingRequest: (location) {
        store.dispatch(
          RechercheRequestAction<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche>(
            RechercheRequest(
              ServiceCiviqueCriteresRecherche(location: location),
              ServiceCiviqueFiltresRecherche.noFiltre(),
              1,
            ),
          ),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState, locations];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheServiceCiviqueState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
