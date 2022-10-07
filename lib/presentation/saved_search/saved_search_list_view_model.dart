import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/saved_search/immersion_saved_search_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/list/offre_emploi_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/saved_search/offre_emploi_saved_search_actions.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/features/service_civique/search/search_service_civique_actions.dart';
import 'package:pass_emploi_app/features/service_civique/search/service_civique_search_result_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionSavedSearch search) {}

void _emptyServiceCiviqueFunction(ServiceCiviqueSavedSearch search) {}

enum SavedSearchNavigationState { OFFRE_EMPLOI, OFFRE_IMMERSION, OFFRE_ALTERNANCE, SERVICE_CIVIQUE, NONE }

class SavedSearchListViewModel extends Equatable {
  final DisplayState displayState;
  final List<SavedSearch> savedSearches;
  final Function(OffreEmploiSavedSearch) offreEmploiSelected;
  final Function(ImmersionSavedSearch) offreImmersionSelected;
  final Function(ServiceCiviqueSavedSearch) offreServiceCiviqueSelected;
  final SavedSearchNavigationState searchNavigationState;
  final Function onRetry;
  final List<Immersion> immersionsResults;

  SavedSearchListViewModel._({
    required this.displayState,
    this.savedSearches = const [],
    this.offreEmploiSelected = _emptyFunction,
    this.offreImmersionSelected = _emptyImmersionFunction,
    this.offreServiceCiviqueSelected = _emptyServiceCiviqueFunction,
    this.searchNavigationState = SavedSearchNavigationState.NONE,
    this.immersionsResults = const [],
    this.onRetry = _emptyVoidFunction,
  });

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    final searchResultState = store.state.offreEmploiListState;
    final immersionListState = store.state.immersionListState;
    final searchParamsState = store.state.offreEmploiSearchParametersState;
    final serviceCiviqueListState = store.state.serviceCiviqueSearchResultState;
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
        searchNavigationState: _getSearchNavigationState(
          searchResultState,
          searchParamsState,
          immersionListState,
          serviceCiviqueListState,
        ),
        immersionsResults: immersionListState is ImmersionListSuccessState ? immersionListState.immersions : [],
        offreEmploiSelected: (savedSearch) => store.dispatch(SavedSearchGetAction(savedSearch.id)),
        offreImmersionSelected: (savedSearch) => store.dispatch(SavedSearchGetAction(savedSearch.id)),
        offreServiceCiviqueSelected: (savedSearch) => store.dispatch(SavedSearchGetAction(savedSearch.id)),
        onRetry: () => store.dispatch(SavedSearchListRequestAction()),
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

  static SavedSearchNavigationState _getSearchNavigationState(
    OffreEmploiListState searchResultState,
    OffreEmploiSearchParametersState searchParamsState,
    ImmersionListState immersionListState,
    ServiceCiviqueSearchResultState serviceCiviqueSearchResultState,
  ) {
    if ((searchResultState is OffreEmploiListSuccessState &&
        searchParamsState is OffreEmploiSearchParametersInitializedState)) {
      return searchParamsState.onlyAlternance
          ? SavedSearchNavigationState.OFFRE_ALTERNANCE
          : SavedSearchNavigationState.OFFRE_EMPLOI;
    } else if (immersionListState is ImmersionListSuccessState) {
      return SavedSearchNavigationState.OFFRE_IMMERSION;
    } else if (serviceCiviqueSearchResultState is ServiceCiviqueSearchResultDataState) {
      return SavedSearchNavigationState.SERVICE_CIVIQUE;
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

  List<ServiceCiviqueSavedSearch> getServiceCivique() {
    return savedSearches.whereType<ServiceCiviqueSavedSearch>().toList();
  }

  static void dispatchSearchRequest(SavedSearch savedSearch, Store<AppState> store) {
    if (savedSearch is ImmersionSavedSearch) {
      SavedSearchListViewModel.onOffreImmersionSelected(savedSearch, store);
    } else if (savedSearch is OffreEmploiSavedSearch) {
      SavedSearchListViewModel.onOffreEmploiSelected(savedSearch, store);
    } else if (savedSearch is ServiceCiviqueSavedSearch) {
      SavedSearchListViewModel.onServiceCiviqueSelected(savedSearch, store);
    }
  }

  static void onOffreEmploiSelected(OffreEmploiSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      SavedOffreEmploiSearchRequestAction(
        keywords: savedSearch.keywords ?? "",
        location: savedSearch.location,
        onlyAlternance: savedSearch.isAlternance,
        filtres: savedSearch.filters,
      ),
    );
  }

  static void onOffreImmersionSelected(ImmersionSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      ImmersionSavedSearchRequestAction(
        codeRome: savedSearch.codeRome,
        location: savedSearch.location,
        filtres: savedSearch.filtres,
      ),
    );
  }

  static void onServiceCiviqueSelected(ServiceCiviqueSavedSearch savedSearch, Store<AppState> store) {
    store.dispatch(
      ServiceCiviqueSavedSearchRequestAction(savedSearch),
    );
  }
}
