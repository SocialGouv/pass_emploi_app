import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

//TODO: 4T: besoin de store => status ou un state générique . status car status non spécifique(isOpen)
//TODO: 4T: besoin de dispatch Result (onExpansionChanged)

class BlocCriteresRechercheViewModel extends Equatable {
  final bool isOpen;
  final Function(bool isOpen) onExpansionChanged;

  BlocCriteresRechercheViewModel({
    required this.isOpen,
    required this.onExpansionChanged,
  });

  factory BlocCriteresRechercheViewModel.create(Store<AppState> store) {
    return BlocCriteresRechercheViewModel(
      isOpen: _isOpen(store),
      onExpansionChanged: (isOpen) {
        if (isOpen) store.dispatch(RechercheNewAction<OffreEmploi>());
      },
    );
  }

  @override
  List<Object?> get props => [isOpen];
}

bool _isOpen(Store<AppState> store) {
  final isOpen = [
    RechercheStatus.nouvelleRecherche,
    RechercheStatus.initialLoading,
    RechercheStatus.failure,
  ].contains(store.state.rechercheEmploiState.status);
  return isOpen;
}
