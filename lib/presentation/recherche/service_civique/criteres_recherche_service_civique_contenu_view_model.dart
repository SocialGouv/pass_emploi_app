import 'package:equatable/equatable.dart';
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
      initialLocation: store.state.rechercheServiceCiviqueState.request?.criteres.location,
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
  List<Object?> get props => [displayState];
}
