import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search_extractors.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum CreateSavedSearchDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

typedef OffreEmploiSavedSearchViewModel = SavedSearchViewModel<OffreEmploiSavedSearch>;

typedef ImmersionSavedSearchViewModel = SavedSearchViewModel<ImmersionSavedSearch>;

typedef ServiceCiviqueSavedSearchViewModel = SavedSearchViewModel<ServiceCiviqueSavedSearch>;

class SavedSearchViewModel<SAVED_SEARCH_MODEL> extends Equatable {
  final Function(String title) createSavedSearch;
  final CreateSavedSearchDisplayState displayState;
  final SAVED_SEARCH_MODEL searchModel;
  final bool Function() savingFailure;

  SavedSearchViewModel._({
    required this.displayState,
    required this.createSavedSearch,
    required this.searchModel,
    required this.savingFailure,
  });

  factory SavedSearchViewModel._create(
      Store<AppState> store, AbstractSearchExtractor<SAVED_SEARCH_MODEL> search, _SearchType type) {
    return SavedSearchViewModel._(
      searchModel: search.getSearchFilters(store),
      displayState: _displayState(
        _getDisplayState(store, type),
      ),
      createSavedSearch: (title) => store.dispatch(
        SavedSearchCreateRequestAction(search.getSearchFilters(store), title),
      ),
      savingFailure: () => search.isFailureState(store),
    );
  }

  static OffreEmploiSavedSearchViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return SavedSearchViewModel._create(store, OffreEmploiSearchExtractor(), _SearchType.EMPLOI);
  }

  static ImmersionSavedSearchViewModel createForImmersion(Store<AppState> store) {
    return SavedSearchViewModel._create(store, ImmersionSearchExtractor(), _SearchType.IMMERSION);
  }

  static ServiceCiviqueSavedSearchViewModel createForServiceCivique(Store<AppState> store) {
    return SavedSearchViewModel._create(store, ServiceCiviqueSearchExtractor(), _SearchType.SERVICE_CIVIQUE);
  }

  @override
  List<Object?> get props => [displayState, createSavedSearch];
}

SavedSearchCreateState<Object> _getDisplayState(Store<AppState> store, _SearchType type) {
  switch (type) {
    case _SearchType.EMPLOI:
      return store.state.offreEmploiSavedSearchCreateState;
    case _SearchType.IMMERSION:
      return store.state.immersionSavedSearchCreateState;
    case _SearchType.SERVICE_CIVIQUE:
      return store.state.serviceCiviqueSavedSearchCreateState;
  }
}

enum _SearchType {
  EMPLOI,
  IMMERSION,
  SERVICE_CIVIQUE,
}

CreateSavedSearchDisplayState _displayState<T>(SavedSearchCreateState<T> savedSearchCreateState) {
  if (savedSearchCreateState is SavedSearchCreateNotInitialized<T>) {
    return CreateSavedSearchDisplayState.SHOW_CONTENT;
  } else if (savedSearchCreateState is SavedSearchCreateLoadingState<T>) {
    return CreateSavedSearchDisplayState.SHOW_LOADING;
  } else if (savedSearchCreateState is SavedSearchCreateSuccessfullyCreated<T>) {
    return CreateSavedSearchDisplayState.TO_DISMISS;
  } else {
    return CreateSavedSearchDisplayState.SHOW_ERROR;
  }
}
