import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';
import 'package:redux/redux.dart';

import '../../actions/saved_search_actions.dart';
import '../../states/app_state.dart';

class SavedSearchListRequestMiddleware extends MiddlewareClass<AppState> {
  final GetSavedSearchRepository repository;

  SavedSearchListRequestMiddleware(this.repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is RequestSavedSearchListAction && loginState is LoginSuccessState) {
      final savedSearchs = await repository.getSavedSearch(loginState.user.id);
      if (savedSearchs == null) {
        store.dispatch(SavedSearchListFailureAction());
      } else {
        store.dispatch(SavedSearchListSuccessAction(savedSearchs));
      }
    }
  }
}
