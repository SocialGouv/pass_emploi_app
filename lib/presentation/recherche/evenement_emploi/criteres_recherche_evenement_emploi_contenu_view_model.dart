import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheEvenementEmploiContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Location? initialLocation;
  final Function(Location location) onSearchingRequest;

  CriteresRechercheEvenementEmploiContenuViewModel({
    required this.displayState,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEvenementEmploiContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEvenementEmploiContenuViewModel(
      displayState: store.state.rechercheEvenementEmploiState.displayState(),
      initialLocation: store.state.rechercheEvenementEmploiState.request?.criteres.location,
      onSearchingRequest: (loc) => _onSearchingRequest(store, loc),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

void _onSearchingRequest(Store<AppState> store, Location location) {
  store.dispatch(
    RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>(
      RechercheRequest(
        EvenementEmploiCriteresRecherche(
          location: location,
        ),
        EvenementEmploiFiltresRecherche(),
        1,
      ),
    ),
  );
}
