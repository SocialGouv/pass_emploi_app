import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/suppression_compte/suppression_compte_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:redux/redux.dart';

class SuppressionCompteMiddleware extends MiddlewareClass<AppState> {
  final SuppressionCompteRepository _repository;

  SuppressionCompteMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is SuppressionCompteRequestAction) {
      store.dispatch(SuppressionCompteLoadingAction());
      final result = await _repository.deleteUser(loginState.user.id);
      if (result) {
        store.dispatch(SuppressionCompteSuccessAction());
        // Wait some delay to ensure suppression state call success snack bar
        await Future.delayed(Duration(milliseconds: 50));
        store.dispatch(RequestLogoutAction(LogoutReason.accountSuppression));
      } else {
        store.dispatch(SuppressionCompteFailureAction());
      }
    }
  }
}
