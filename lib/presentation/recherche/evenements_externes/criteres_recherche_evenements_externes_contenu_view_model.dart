import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheEvenementsExternesContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Location? initialLocation;
  final Function(Location location) onSearchingRequest;

  CriteresRechercheEvenementsExternesContenuViewModel({
    required this.displayState,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEvenementsExternesContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEvenementsExternesContenuViewModel(
      displayState: store.state.rechercheEvenementsExternesState.displayState(),
      initialLocation: store.state.rechercheEvenementsExternesState.request?.criteres.location,
      onSearchingRequest: (loc) => _onSearchingRequest(store, loc),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

void _onSearchingRequest(Store<AppState> store, Location location) {
  store.dispatch(
    RechercheRequestAction<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche>(
      RechercheRequest(
        EvenementsExternesCriteresRecherche(
          location: location,
        ),
        EvenementsExternesFiltresRecherche(),
        1,
      ),
    ),
  );
}
