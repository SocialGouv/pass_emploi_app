import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

void _emptyFunction(OffreEmploiSavedSearch search) {}

void _emptyVoidFunction() {}

void _emptyImmersionFunction(ImmersionSavedSearch search) {}

void _emptyServiceCiviqueFunction(ServiceCiviqueSavedSearch search) {}

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
    if (state is SavedSearchListLoadingState) return SavedSearchListViewModel._(displayState: DisplayState.LOADING);
    if (state is SavedSearchListFailureState) return SavedSearchListViewModel._(displayState: DisplayState.FAILURE);
    if (state is SavedSearchListSuccessState) {
      return SavedSearchListViewModel._(
        displayState: DisplayState.CONTENT,
        savedSearches: state.savedSearches.toList(),
        searchNavigationState: SavedSearchNavigationState.fromAppState(store.state),
        immersionsResults: store.state.rechercheImmersionState.results ?? [],
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

  List<OffreEmploiSavedSearch> getOffresEmploi() {
    return savedSearches
        .whereType<OffreEmploiSavedSearch>()
        .where((element) => element.onlyAlternance == false)
        .toList();
  }

  List<OffreEmploiSavedSearch> getAlternance() {
    return savedSearches
        .whereType<OffreEmploiSavedSearch>()
        .where((element) => element.onlyAlternance == true)
        .toList();
  }

  List<ImmersionSavedSearch> getImmersions() => savedSearches.whereType<ImmersionSavedSearch>().toList();

  List<ServiceCiviqueSavedSearch> getServiceCivique() => savedSearches.whereType<ServiceCiviqueSavedSearch>().toList();
}
