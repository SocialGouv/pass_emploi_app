import 'package:flutter/cupertino.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:redux/redux.dart';

import '../../redux/actions/saved_search_actions.dart';
import '../../redux/states/app_state.dart';

class SavedSearchListViewModel {
  final DisplayState displayState;
  final List savedSearch;
  final VoidCallback onRetry;

  SavedSearchListViewModel._(this.displayState, this.savedSearch, this.onRetry);

  factory SavedSearchListViewModel.createFromStore(Store<AppState> store) {
    final state = store.state.savedSearchListState;
    if (state.isLoading())
      return SavedSearchListViewModel._(DisplayState.LOADING, [], () => store.dispatch(RequestSavedSearchListAction()));
    if (state.isFailure())
      return SavedSearchListViewModel._(DisplayState.FAILURE, [], () => store.dispatch(RequestSavedSearchListAction()));
    if (state.isSuccess())
      return SavedSearchListViewModel._(
          DisplayState.CONTENT, state.getResultOrThrow(), () => store.dispatch(RequestSavedSearchListAction()));
    return SavedSearchListViewModel._(DisplayState.LOADING, [], () => store.dispatch(RequestSavedSearchListAction()));
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
}
