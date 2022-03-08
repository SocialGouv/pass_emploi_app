import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_request.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:redux/redux.dart';

import '../../models/saved_search/saved_search.dart';
import '../../redux/states/app_state.dart';
import '../../redux/states/offre_emploi_search_parameters_state.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionSavedSearch search) {}

enum SavedSearchNavigationState { OFFRE_EMPLOI, OFFRE_IMMERSION, OFFRE_ALTERNANCE, NONE }

class SavedSearchListViewModel extends Equatable {
  final DisplayState displayState;
  final List<SavedSearch> savedSearches;
  final Function(OffreEmploiSavedSearch) offreEmploiSelected;
  final Function(ImmersionSavedSearch) offreImmersionSelected;
  final SavedSearchNavigationState searchNavigationState;
  final Function onRetry;
  final List<Immersion> immersionsResults;

  SavedSearchListViewModel._({
    required this.displayState,
    this.savedSearches = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.offreImmersionSelected = _emptyImmersionFunction,
    this.searchNavigationState = SavedSearchNavigationState.NONE,
    this.immersionsResults = const [],
    this.onRetry = _emptyVoidFunction,
  });

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    final searchResultState = store.state.offreEmploiListState;
    final immersionListState = store.state.immersionListState;
    final searchParamsState = store.state.offreEmploiSearchParametersState;
    if (state is SavedSearchListLoadingState) {
      return SavedSearchListViewModel._(displayState: DisplayState.LOADING);
    }
    if (state is SavedSearchListFailureState) {
      return SavedSearchListViewModel._(displayState: DisplayState.FAILURE);
    }
    if (state is SavedSearchListSuccessState) {
      return SavedSearchListViewModel._(
        displayState: DisplayState.CONTENT,
        savedSearches: state.savedSearches.toList(),
        searchNavigationState: _getSearchNavigationState(searchResultState, searchParamsState, immersionListState),
        immersionsResults: immersionListState is ImmersionListSuccessState ? immersionListState.immersions : [],
        offreEmploiSelected: (savedSearch) => onOffreEmploiSelected(savedSearch, store),
        offreImmersionSelected: (savedSearch) => onOffreImmersionSelected(savedSearch, store),
      );
    }
    return SavedSearchListViewModel._(displayState: DisplayState.LOADING);
  }

  @override
  List<Object?> get props => [
        displayState,
        savedSearches,
        immersionsResults,
        searchNavigationState,
        immersionsResults,
      ];

  static SavedSearchNavigationState _getSearchNavigationState(OffreEmploiListState searchResultState,
      OffreEmploiSearchParametersState searchParamsState, ImmersionListState immersionListState) {
    if ((searchResultState is OffreEmploiListSuccessState &&
        searchParamsState is OffreEmploiSearchParametersInitializedState)) {
      return searchParamsState.onlyAlternance
          ? SavedSearchNavigationState.OFFRE_ALTERNANCE
          : SavedSearchNavigationState.OFFRE_EMPLOI;
    } else if (immersionListState is ImmersionListSuccessState) {
      return SavedSearchNavigationState.OFFRE_IMMERSION;
    } else {
      return SavedSearchNavigationState.NONE;
    }
  }

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
      ImmersionListRequestAction(
        ImmersionListRequest(
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
