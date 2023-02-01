import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class BlocCriteresRechercheContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Function(String) onSearch;

  BlocCriteresRechercheContenuViewModel({required this.displayState, required this.onSearch});

  factory BlocCriteresRechercheContenuViewModel.create(Store<AppState> store) {
    return BlocCriteresRechercheContenuViewModel(
      displayState: _displayState(store),
      onSearch: (keyword) {
        store.dispatch(RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>(
          RechercheRequest(
            // TODO: 1353 - Vraie recherche
            EmploiCriteresRecherche(
              keywords: 'boulanger',
              location: null,
              onlyAlternance: false,
            ),
            OffreEmploiSearchParametersFiltres.noFiltres(),
            1,
          ),
        ));
      },
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheEmploiState.status;
  if (status == RechercheStatus.loading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
