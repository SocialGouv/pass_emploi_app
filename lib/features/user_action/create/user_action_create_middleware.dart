import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

class UserActionCreateMiddleware extends MiddlewareClass<AppState> {
  final PageActionRepository _repository;

  UserActionCreateMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is UserActionCreateRequestAction) {
      store.dispatch(UserActionCreateLoadingAction());
      final creation = await _repository.createUserAction(loginState.user.id, action.request);
      if (creation != null) {
        _handleUserActionCreation(store, creation);
      } else {
        store.dispatch(UserActionCreateFailureAction());
      }
    }
  }

  void _handleUserActionCreation(Store<AppState> store, UserActionCreation creation) {
    if (creation is RemoteUserActionCreation) {
      store.dispatch(UserActionCreateSuccessAction(creation.userActionId));
      store.dispatch(UserActionListRequestAction());
      store.dispatch(AgendaRequestAction(DateTime.now()));
    } else if (creation is LocalUserActionCreation) {
      store.dispatch(UserActionCreateSuccessAction(creation.userActionId, localCreationOnly: true));
    }
  }
}
