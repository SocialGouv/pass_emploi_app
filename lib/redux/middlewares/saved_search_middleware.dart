import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchMiddleware<T> extends MiddlewareClass<AppState> {
  final SavedSearchRepository<T> _repository;

  SavedSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is RequestPostSavedSearchAction<T> && loginState.isSuccess()) {
      await _saveSearch(store, action, loginState.getResultOrThrow().id);
    }
  }

  Future<void> _saveSearch(
    Store<AppState> store,
    RequestPostSavedSearchAction<T> action,
    String userId,
  ) async {
    var emploiSavedSearchState = store.state.offreEmploiSavedSearchState;
    var savedSearch = _extractSearch(emploiSavedSearchState);
    final result = await _repository.postSavedSearch(
      userId,
      savedSearch,
    );
    if (result) {
      store.dispatch(SavedSearchSuccessAction<T>());
    } else {
      store.dispatch(SavedSearchFailureAction<T>());
    }
  }

  dynamic _extractSearch(SavedSearchState<OffreEmploiSavedSearch> emploiSavedSearchState) {
    if (emploiSavedSearchState is SavedSearchInitialized) {
      return (emploiSavedSearchState as SavedSearchInitialized).search;
    } else {
      return null;
    }
  }
}
