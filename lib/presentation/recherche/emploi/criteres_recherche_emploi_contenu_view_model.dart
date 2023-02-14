import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_state_to_display_state_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CriteresRechercheEmploiContenuViewModel extends Equatable {
  final DisplayState displayState;
  final String? initiaKeyword;
  final Location? initialLocation;
  final Function(String keyword, Location? location, bool onlyAlternance) onSearchingRequest;

  CriteresRechercheEmploiContenuViewModel({
    required this.displayState,
    required this.initiaKeyword,
    required this.initialLocation,
    required this.onSearchingRequest,
  });

  factory CriteresRechercheEmploiContenuViewModel.create(Store<AppState> store) {
    return CriteresRechercheEmploiContenuViewModel(
      displayState: store.state.rechercheEmploiState.displayState(),
      initiaKeyword: store.state.rechercheEmploiState.request?.criteres.keyword,
      initialLocation: store.state.rechercheEmploiState.request?.criteres.location,
      onSearchingRequest: (keyword, location, onlyAlternance) {
        store.dispatch(
          RechercheRequestAction<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            RechercheRequest(
              EmploiCriteresRecherche(keyword: keyword, location: location, onlyAlternance: onlyAlternance),
              EmploiFiltresRecherche.noFiltre(),
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
