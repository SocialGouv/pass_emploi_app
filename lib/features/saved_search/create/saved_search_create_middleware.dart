import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_actions.dart';
import 'package:pass_emploi_app/features/saved_search/create/saved_search_create_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';
import 'package:redux/redux.dart';

abstract class SavedSearchCreateMiddleware<T> extends MiddlewareClass<AppState> {
  final SavedSearchRepository<T> _repository;

  SavedSearchCreateMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SavedSearchCreateRequestAction<T> && loginState is LoginSuccessState) {
      await _saveSearch(store, action, loginState.user.id);
    }
  }

  Future<void> _saveSearch(Store<AppState> store, SavedSearchCreateRequestAction<T> action, String userId) async {
    final savedSearchState = getSavedSearchCreateState(store);
    final T? t = savedSearchState is SavedSearchCreateInitialized<T> ? savedSearchState.search : null;
    if (t == null) {
      store.dispatch(SavedSearchCreateFailureAction<T>());
    } else {
      final result = await _repository.postSavedSearch(userId, t, action.title);
      store.dispatch(
        result
            ? SavedSearchCreateSuccessAction<T>(copyWithTitle(t, action.title))
            : SavedSearchCreateFailureAction<T>(),
      );
    }
  }

  SavedSearchCreateState<T> getSavedSearchCreateState(Store<AppState> store);

  T copyWithTitle(T t, String title);
}
