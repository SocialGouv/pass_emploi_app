import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

//TODO(1356): store vers status ou state générique (pour display state)
//TODO(1356): tests

class CriteresRechercheImmersionContenuViewModel extends Equatable {
  final DisplayState displayState;
  final List<LocationViewModel> locations;
  final List<Metier> metiers;
  final Function(String? input) onInputLocation;
  final Function(String? input) onInputMetier;
  //TODO(1356): avant il y avait aussi title envoyé, utile ? => refactor pour retenir le metier dans le critere
  final Function(String codeRome, Location location) onSearchingRequest;

  CriteresRechercheImmersionContenuViewModel({
    required this.displayState,
    required this.locations,
    required this.metiers,
    required this.onInputLocation,
    required this.onInputMetier,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheImmersionContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheImmersionContenuViewModel(
      displayState: _displayState(store),
      locations: store.state.searchLocationState.locations
          .map((location) => LocationViewModel.fromLocation(location))
          .toList(),
      metiers: store.state.searchMetierState.metiers,
      onInputLocation: (input) => store.dispatch(SearchLocationRequestAction(input, villesOnly: true)),
      onInputMetier: (input) => store.dispatch(SearchMetierRequestAction(input)),
      onSearchingRequest: (codeRome, location) {
        store.dispatch(
          RechercheRequestAction<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres>(
            RechercheRequest(
              ImmersionCriteresRecherche(codeRome: codeRome, location: location),
              ImmersionSearchParametersFiltres.noFiltres(),
              1,
            ),
          ),
        );
      },
    );
  }

  @override
  List<Object?> get props => [displayState, locations, metiers];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheImmersionState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
