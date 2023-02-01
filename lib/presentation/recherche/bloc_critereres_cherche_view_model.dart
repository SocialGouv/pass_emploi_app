import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:redux/redux.dart';

class BlocCriteresRechercheViewModel extends Equatable {
  final bool isOpen;
  final Function(String keywords, Location? location, bool onlyAlternance) onSearchingRequest;

  BlocCriteresRechercheViewModel({
    required this.isOpen,
    required this.onSearchingRequest,
  });

  factory BlocCriteresRechercheViewModel.create(Store<AppState> store) {
    final isOpen = [
      RechercheStatus.newSearch,
      RechercheStatus.loading,
      RechercheStatus.failure,
    ].contains(store.state.rechercheEmploiState.status);
    return BlocCriteresRechercheViewModel(
      isOpen: isOpen,
      onSearchingRequest: (keywords, location, onlyAlternance) {
        store.dispatch(RechercheRequestAction<EmploiCriteresRecherche, OffreEmploiSearchParametersFiltres>(
          RechercheRequest(
            EmploiCriteresRecherche(keywords: keywords, location: location, onlyAlternance: onlyAlternance),
            OffreEmploiSearchParametersFiltres.noFiltres(),
            1,
          ),
        ));
      },
    );
  }

  @override
  List<Object?> get props => [isOpen];
}
