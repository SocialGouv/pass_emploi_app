import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RecherchesRecentesViewModel extends Equatable {
  final SavedSearchNavigationState searchNavigationState;
  final SavedSearch? rechercheRecente;
  final Function(SavedSearch) fetchSavedSearchResult;

  RecherchesRecentesViewModel({
    required this.searchNavigationState,
    required this.rechercheRecente,
    required this.fetchSavedSearchResult,
  });

  static RecherchesRecentesViewModel create(Store<AppState> store) {
    final state = store.state.recherchesRecentesState;
    return RecherchesRecentesViewModel(
      searchNavigationState: SavedSearchNavigationState.fromAppState(store.state),
      rechercheRecente: state.recentSearches.firstOrNull,
      fetchSavedSearchResult: (savedSearch) => store.dispatch(FetchSavedSearchResultsAction(savedSearch)),
    );
  }

  @override
  List<Object?> get props => [searchNavigationState, rechercheRecente];
}
