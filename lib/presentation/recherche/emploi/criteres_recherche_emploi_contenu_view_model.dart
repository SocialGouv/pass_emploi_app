import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

//TODO: 4T: sortir un VM dédié à location ?
//TODO: 4T: store vers status ou state générique (pour display state)

class CriteresRechercheEmploiContenuViewModel extends Equatable {
  final DisplayState displayState;
  final List<LocationViewModel> locations;
  final Function(String? input) onInputLocation;
  final Function(String keywords, Location? location, bool onlyAlternance) onSearchingRequest;

  CriteresRechercheEmploiContenuViewModel({
    required this.displayState,
    required this.locations,
    required this.onInputLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEmploiContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEmploiContenuViewModel(
      displayState: _displayState(store),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input)),
      onSearchingRequest: (keywords, location, onlyAlternance) {
        store.dispatch(
          RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>(
            RechercheRequest(
              EmploiCriteresRecherche(keywords: keywords, location: location, onlyAlternance: onlyAlternance),
              OffreEmploiSearchParametersFiltres.noFiltres(),
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
  final status = store.state.rechercheEmploiState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
