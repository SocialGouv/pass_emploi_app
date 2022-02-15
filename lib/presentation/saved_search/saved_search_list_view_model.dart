import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:redux/redux.dart';

import '../../redux/actions/saved_search_actions.dart';
import '../../redux/states/app_state.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

class SavedSearchListViewModel {
  final DisplayState displayState;
  final List savedSearch;
  final Function(OffreEmploiSavedSearch) offreEmploiSelected;
  final bool shouldGoToOffre;
  final VoidCallback onRetry;

  SavedSearchListViewModel._({
    required this.displayState,
    this.savedSearch = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.shouldGoToOffre = false,
    this.onRetry = _emptyFunction,
  });

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    final searchResultState = store.state.offreEmploiSearchResultsState ;
    if (state.isLoading())
      return SavedSearchListViewModel._(
        displayState: DisplayState.LOADING,
      );
    if (state.isFailure())
      return SavedSearchListViewModel._(
        displayState: DisplayState.FAILURE,
      );
    if (state.isSuccess())
      return SavedSearchListViewModel._(
        displayState: DisplayState.CONTENT,
        savedSearch: state.getResultOrThrow(),
        shouldGoToOffre: searchResultState is OffreEmploiSearchResultsDataState,
        offreEmploiSelected: (savedSearch) => _offreEmploiSelected(savedSearch, store),

      );
    return SavedSearchListViewModel._(
      displayState: DisplayState.LOADING,
    );
  }

  List<OffreEmploiSavedSearch> getOffresEmploi(bool withAlternance) {
    return savedSearch
        .whereType<OffreEmploiSavedSearch>()
        .where((element) => element.isAlternance == withAlternance)
        .toList();
  }

  List<ImmersionSavedSearch> getImmersions() {
    return savedSearch.whereType<ImmersionSavedSearch>().toList();
  }

  static void _offreEmploiSelected(OffreEmploiSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      OffreEmploiSearchWithFiltresAction(
        keywords: savedSearch.keywords ?? "",
        location: savedSearch.location,
        onlyAlternance: savedSearch.isAlternance,
        updatedFiltres: savedSearch.filters,
      ),
    );
  }
}
