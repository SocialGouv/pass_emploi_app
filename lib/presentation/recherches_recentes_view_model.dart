import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RecherchesRecentesViewModel extends Equatable {
  final SavedSearch? rechercheRecente;

  RecherchesRecentesViewModel({
    required this.rechercheRecente,
  });

  static RecherchesRecentesViewModel create(Store<AppState> store) {
    final state = store.state.recherchesRecentesState;
    return RecherchesRecentesViewModel(
      rechercheRecente: state.recentSearches.derniereRechercheOffre(),
    );
  }

  @override
  List<Object?> get props => [rechercheRecente];
}

extension _RechercheRecentesList on List<SavedSearch> {
  SavedSearch? derniereRechercheOffre() {
    return firstWhereOrNull((element) {
      return element is OffreEmploiSavedSearch ||
          element is ImmersionSavedSearch ||
          element is ServiceCiviqueSavedSearch;
    });
  }
}
