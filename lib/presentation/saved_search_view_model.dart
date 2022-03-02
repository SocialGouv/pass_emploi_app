import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../models/saved_search/saved_search_extractors.dart';

enum CreateSavedSearchDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

typedef OffreEmploiSavedSearchViewModel = SavedSearchViewModel<OffreEmploiSavedSearch>;

typedef ImmersionSavedSearchViewModel = SavedSearchViewModel<ImmersionSavedSearch>;

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
      Store<AppState> store, AbstractSearchExtractor<SAVED_SEARCH_MODEL> search, bool isImmersion) {
    return SavedSearchViewModel._(
      searchModel: search.getSearchFilters(store),
      displayState: _displayState(
        isImmersion ? store.state.immersionSavedSearchCreateState : store.state.offreEmploiSavedSearchCreateState,
      ),
      createSavedSearch: (title) => store.dispatch(
        SavedSearchCreateRequestAction(search.getSearchFilters(store), title),
      ),
      savingFailure: () => search.isFailureState(store),
    );
  }

  static OffreEmploiSavedSearchViewModel createForOffreEmploi(Store<AppState> store, {required bool onlyAlternance}) {
    return SavedSearchViewModel._create(store, OffreEmploiSearchExtractor(), false);
  }

  static ImmersionSavedSearchViewModel createForImmersion(Store<AppState> store) {
    return SavedSearchViewModel._create(store, ImmersionSearchExtractor(), true);
  }

  @override
  List<Object?> get props => [displayState, createSavedSearch];
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
