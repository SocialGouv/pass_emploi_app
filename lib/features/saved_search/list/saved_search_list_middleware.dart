import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/list/saved_search_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchListMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository _repository;

  SavedSearchListMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is SavedSearchListRequestAction) {
      store.dispatch(SavedSearchListLoadingAction());
      final savedSearches = await _repository.getSavedSearch(loginState.user.id);
      store.dispatch(
        savedSearches != null ? SavedSearchListSuccessAction(savedSearches) : SavedSearchListFailureAction(),
      );
    }
  }
}
