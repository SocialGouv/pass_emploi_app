import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/saved_search/delete/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:redux/redux.dart';

class SavedSearchDeleteMiddleware extends MiddlewareClass<AppState> {
  final SavedSearchDeleteRepository repository;

  SavedSearchDeleteMiddleware(this.repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is SavedSearchDeleteRequestAction) {
      store.dispatch(SavedSearchDeleteLoadingAction());
      final success = await repository.delete(loginState.user.id, action.savedSearchId);
      store.dispatch(success ? SavedSearchDeleteSuccessAction(action.savedSearchId) : SavedSearchDeleteFailureAction());
    }
  }
}
