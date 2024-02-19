import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && action is RendezvousDetailsRequestAction) {
      store.dispatch(RendezvousDetailsLoadingAction());
      final rdv = await _repository.getRendezvousMilo(loginState.user.id, action.rendezvousId);
      store.dispatch(rdv != null ? RendezvousDetailsSuccessAction(rdv) : RendezvousDetailsFailureAction());
    }
  }
}
