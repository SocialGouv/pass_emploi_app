import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestRendezvousAction) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        store.dispatch(RendezvousLoadingAction());
        final rendezvous = await _repository.getRendezvous(loginState.user.id);
        store.dispatch(rendezvous != null ? RendezvousSuccessAction(rendezvous) : RendezvousFailureAction());
      }
    }
  }
}
