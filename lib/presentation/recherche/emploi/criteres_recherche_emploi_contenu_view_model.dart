import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheEmploiContenuViewModel extends Equatable {
  final DisplayState displayState;
  final String? initialKeyword;
  final Location? initialLocation;
  final Function(String keyword, Location? location, bool onlyAlternance) onSearchingRequest;

  CriteresRechercheEmploiContenuViewModel({
    required this.displayState,
    required this.initialKeyword,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEmploiContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEmploiContenuViewModel(
      displayState: store.state.rechercheEmploiState.displayState(),
      initialKeyword: store.state.rechercheEmploiState.request?.criteres.keyword,
      initialLocation: store.state.rechercheEmploiState.request?.criteres.location,
      onSearchingRequest: (keyword, loc, onlyAlternance) => _onSearchingRequest(store, keyword, loc, onlyAlternance),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

void _onSearchingRequest(Store<AppState> store, String keyword, Location? location, bool onlyAlternance) {
  final brand = store.state.configurationState.getBrand();
  final previousRequest = store.state.rechercheEmploiState.request;
  final initialRecherche = previousRequest == null;
  store.dispatch(
    RechercheRequestAction<EmploiCriteresRecherche, EmploiFiltresRecherche>(
      RechercheRequest(
        EmploiCriteresRecherche(
          keyword: keyword,
          location: location,
          rechercheType:
              brand.isPassEmploi ? RechercheType.offreEmploiAndAlternance : RechercheType.from(onlyAlternance),
        ),
        initialRecherche
            ? EmploiFiltresRecherche.noFiltre()
            : _previousFiltresUpdated(previousRequest.filtres, location),
        1,
      ),
    ),
  );
}

EmploiFiltresRecherche _previousFiltresUpdated(EmploiFiltresRecherche currentFiltres, Location? location) {
  if (location == null || location.type == LocationType.DEPARTMENT) {
    return EmploiFiltresRecherche.withFiltres(
      distance: null,
      debutantOnly: currentFiltres.debutantOnly,
      experience: currentFiltres.experience,
      contrat: currentFiltres.contrat,
      duree: currentFiltres.duree,
    );
  } else {
    return currentFiltres;
  }
}
