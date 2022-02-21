import 'package:redux/redux.dart';

import '../../../repositories/saved_search/saved_search_delete_repository.dart';
import '../../actions/saved_search_actions.dart';
import '../../states/app_state.dart';

class SavedSearchDeleteMiddleware extends MiddlewareClass<AppState> {
  final SavedSearchDeleteRepository repository;

  SavedSearchDeleteMiddleware(this.repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is SavedSearchDeleteRequestAction) {
      store.dispatch(SavedSearchDeleteLoadingAction());
      final success = await repository.delete(loginState.getResultOrThrow().id, action.savedSearchId);
      store.dispatch(success ? SavedSearchDeleteSuccessAction(action.savedSearchId) : SavedSearchDeleteFailureAction());
    }
  }
}
