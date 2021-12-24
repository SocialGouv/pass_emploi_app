import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:redux/redux.dart';

class RegisterPushNotificationTokenMiddleware extends MiddlewareClass<AppState> {
  final RegisterTokenRepository _repository;

  RegisterPushNotificationTokenMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is LoginAction && action.isSuccess()) {
      _repository.registerToken(action.getDataOrThrow().id);
    }
  }
}
