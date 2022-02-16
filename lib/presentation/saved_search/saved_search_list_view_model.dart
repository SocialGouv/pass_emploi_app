import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:redux/redux.dart';

import '../../redux/states/app_state.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionSavedSearch search) {}

class SavedSearchListViewModel {
  final DisplayState displayState;
  final List savedSearch;
  final Function(OffreEmploiSavedSearch) offreEmploiSelected;
  final Function(ImmersionSavedSearch) offreImmersionSelected;
  final bool shouldGoToOffre;
  final VoidCallback onRetry;
  final List<Immersion> immersionsResults;

  SavedSearchListViewModel._({
    required this.displayState,
    this.savedSearch = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.offreImmersionSelected = _emptyImmersionFunction,
    this.shouldGoToOffre = false,
    this.immersionsResults = const [],
    this.onRetry = _emptyVoidFunction,
  });

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    final searchResultState = store.state.offreEmploiSearchResultsState;
    final immersionSearchState = store.state.immersionSearchState;
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
        immersionsResults: immersionSearchState.isSuccess() ? immersionSearchState.getResultOrThrow() : [],
        offreEmploiSelected: (savedSearch) => _offreEmploiSelected(savedSearch, store),
        offreImmersionSelected: (savedSearch) => _offreImmersionSelected(savedSearch, store),
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

  static void _offreImmersionSelected(ImmersionSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(ImmersionAction.request(ImmersionRequest(
      savedSearch.filters!.codeRome!,
      Location(
        type: LocationType.COMMUNE,
        libelle: savedSearch.location,
        code: "",
        latitude: savedSearch.filters!.lat!,
        longitude: savedSearch.filters!.lon!,
      ),
    )));
  }
}
