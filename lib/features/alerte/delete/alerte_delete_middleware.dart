import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';
import 'package:redux/redux.dart';

class AlerteDeleteMiddleware extends MiddlewareClass<AppState> {
  final AlerteDeleteRepository repository;

  AlerteDeleteMiddleware(this.repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is AlerteDeleteRequestAction) {
      store.dispatch(AlerteDeleteLoadingAction());
      final success = await repository.delete(loginState.user.id, action.alerteId);
      store.dispatch(success ? AlerteDeleteSuccessAction(action.alerteId) : AlerteDeleteFailureAction());
    }
  }
}
