import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

abstract class SavedSearchMiddleware<T> extends MiddlewareClass<AppState> {
  final SavedSearchRepository<T> _repository;

  SavedSearchMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is RequestPostSavedSearchAction<T> && loginState is LoginSuccessState) {
      await _saveSearch(store, action, loginState.user.id);
    }
  }

  Future<void> _saveSearch(Store<AppState> store, RequestPostSavedSearchAction<T> action, String userId) async {
    final savedSearchState = getSavedSearchState(store);
    final T? t = savedSearchState is SavedSearchInitialized<T> ? savedSearchState.search : null;
    if (t == null) {
      store.dispatch(SavedSearchFailureAction<T>());
    } else {
      final result = await _repository.postSavedSearch(userId, t, action.title);
      store.dispatch(
        result ? SavedSearchSuccessAction<T>(copyWithTitle(t, action.title)) : SavedSearchFailureAction<T>(),
      );
    }
  }

  SavedSearchState<T> getSavedSearchState(Store<AppState> store);

  T copyWithTitle(T t, String title);
}
