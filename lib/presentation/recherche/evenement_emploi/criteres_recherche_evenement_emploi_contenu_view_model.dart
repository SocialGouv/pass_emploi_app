import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_state.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheEvenementEmploiContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Location? initialLocation;
  final SecteurActivite? initialSecteurActivite;
  final Function(EvenementEmploiCriteresRecherche criteresRecherche) onSearchingRequest;

  CriteresRechercheEvenementEmploiContenuViewModel({
    required this.displayState,
    required this.initialLocation,
    required this.initialSecteurActivite,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEvenementEmploiContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEvenementEmploiContenuViewModel(
      displayState: store.state.rechercheEvenementEmploiState.displayState(),
      initialLocation:
          store.state.rechercheEvenementEmploiState.request?.criteres.location ?? store.getLastLocationSelected(),
      initialSecteurActivite: store.state.rechercheEvenementEmploiState.request?.criteres.secteurActivite,
      onSearchingRequest: (criteresRecherche) => _onSearchingRequest(store, criteresRecherche),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

void _onSearchingRequest(Store<AppState> store, EvenementEmploiCriteresRecherche criteresRecherche) {
  store.dispatch(
    RechercheRequestAction<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche>(
      RechercheRequest(criteresRecherche, EvenementEmploiFiltresRecherche.noFiltre(), 1),
    ),
  );
}
