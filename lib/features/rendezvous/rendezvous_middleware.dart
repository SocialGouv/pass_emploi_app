import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is RendezvousRequestAction) {
      store.dispatch(RendezvousLoadingAction());
      final result = await _repository.getRendezvous(loginState.user.id);
      store.dispatch(result != null ? RendezvousSuccessAction(result) : RendezvousFailureAction());
    }
  }
}
