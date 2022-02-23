import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import '../../models/saved_search/saved_search.dart';
import '../states/saved_search_delete_state.dart';
import '../states/state.dart';
import '../store/environment.dart';

class SavedSearchDeleteRequestAction extends ReduxAction<AppState> {
  final String savedSearchId;

  SavedSearchDeleteRequestAction(this.savedSearchId);

  @override
  Future<void> before() => store.dispatchAsync(SavedSearchDeleteLoadingAction());

  @override
  Environment get env => super.env as Environment;

  @override
  Future<AppState?> reduce() async {
    final loginState = env.storeV1.state.loginState;
    final success = await env.savedSearchDeleteRepository.delete(loginState.getResultOrThrow().id, savedSearchId);
    final currentSavedSearchesState = env.storeV1.state.savedSearchesState;
    if (success && currentSavedSearchesState.isSuccess()) {
      final List<SavedSearch> savedSearches = currentSavedSearchesState.getResultOrThrow();
      savedSearches.removeWhere((element) => element.getId() == savedSearchId);
      return state.copyWith(
        savedSearchesState: State<List<SavedSearch>>.success(savedSearches),
        savedSearchDeleteState: SavedSearchDeleteState.success(),
      );
    } else if (success && !currentSavedSearchesState.isSuccess()) {
      return state.copyWith(savedSearchDeleteState: SavedSearchDeleteState.success());
    } else {
      return state.copyWith(savedSearchDeleteState: SavedSearchDeleteState.failure());
    }
  }
}

class SavedSearchDeleteLoadingAction extends ReduxAction<AppState> {
  @override
  AppState reduce() => state.copyWith(savedSearchDeleteState: SavedSearchDeleteState.loading());
}

class SavedSearchDeleteResetAction extends ReduxAction<AppState> {
  @override
  AppState reduce() => state.copyWith(savedSearchDeleteState: SavedSearchDeleteState.notInitialized());
}
