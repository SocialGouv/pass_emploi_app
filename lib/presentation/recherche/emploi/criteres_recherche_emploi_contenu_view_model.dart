import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

//TODO: 1353 - 4T: store vers status ou state générique (pour display state)
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
      displayState: _displayState(store),
      initiaKeyword: store.state.rechercheEmploiState.request?.criteres.keyword,
      initialLocation: store.state.rechercheEmploiState.request?.criteres.location,
      onSearchingRequest: (keyword, location, onlyAlternance) {
        store.dispatch(
          RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>(
            RechercheRequest(
              EmploiCriteresRecherche(keyword: keyword, location: location, onlyAlternance: onlyAlternance),
              OffreEmploiSearchParametersFiltres.noFiltres(),
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

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheEmploiState.status;
  if (status == RechercheStatus.initialLoading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
