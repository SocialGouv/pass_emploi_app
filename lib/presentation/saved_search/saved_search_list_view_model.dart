import 'package:equatable/equatable.dart';
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

import '../../models/saved_search/saved_search.dart';
import '../../redux/states/app_state.dart';
import '../../redux/states/offre_emploi_search_parameters_state.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionSavedSearch search) {}

class SavedSearchListViewModel extends Equatable {
  final DisplayState displayState;
  final List<SavedSearch> savedSearches;
  final Function(OffreEmploiSavedSearch) offreEmploiSelected;
  final Function(ImmersionSavedSearch) offreImmersionSelected;
  final bool? shouldGoToOffre;
  final bool shouldGoToImmersion;
  final VoidCallback onRetry;
  final List<Immersion> immersionsResults;

  SavedSearchListViewModel._({
    required this.displayState,
    this.savedSearches = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.offreImmersionSelected = _emptyImmersionFunction,
    this.shouldGoToOffre,
    this.shouldGoToImmersion = false,
    this.immersionsResults = const [],
    this.onRetry = _emptyVoidFunction,
  });

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchesState;
    final searchResultState = store.state.offreEmploiSearchResultsState;
    final immersionSearchState = store.state.immersionSearchState;
    final searchParamsState = store.state.offreEmploiSearchParametersState;
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
        savedSearches: state.getResultOrThrow().toList(),
        shouldGoToOffre: (searchResultState is OffreEmploiSearchResultsDataState &&
                searchParamsState is OffreEmploiSearchParametersInitializedState)
            ? searchParamsState.onlyAlternance
            : null,
        shouldGoToImmersion: immersionSearchState.isSuccess(),
        immersionsResults: immersionSearchState.isSuccess() ? immersionSearchState.getResultOrThrow() : [],
        offreEmploiSelected: (savedSearch) => onOffreEmploiSelected(savedSearch, store),
        offreImmersionSelected: (savedSearch) => onOffreImmersionSelected(savedSearch, store),
      );
    }
    return SavedSearchListViewModel._(displayState: DisplayState.LOADING);
  }

  @override
  List<Object?> get props =>
      [
        displayState,
        savedSearches,
        immersionsResults,
        shouldGoToOffre,
        shouldGoToImmersion,
      ];

  List<OffreEmploiSavedSearch> getOffresEmploi(bool withAlternance) {
    return savedSearches
        .whereType<OffreEmploiSavedSearch>()
        .where((element) => element.isAlternance == withAlternance)
        .toList();
  }

  List<ImmersionSavedSearch> getImmersions() {
    return savedSearches.whereType<ImmersionSavedSearch>().toList();
  }

  static void onOffreEmploiSelected(OffreEmploiSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      OffreEmploiSearchWithFiltresAction(
        keywords: savedSearch.keywords ?? "",
        location: savedSearch.location,
        onlyAlternance: savedSearch.isAlternance,
        updatedFiltres: savedSearch.filters,
      ),
    );
  }

  static void onOffreImmersionSelected(ImmersionSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      ImmersionAction.request(
        ImmersionRequest(
          savedSearch.filters!.codeRome!,
          Location(
            type: LocationType.COMMUNE,
            libelle: savedSearch.location,
            code: "",
            latitude: savedSearch.filters!.lat!,
            longitude: savedSearch.filters!.lon!,
          ),
        ),
      ),
    );
  }
}
