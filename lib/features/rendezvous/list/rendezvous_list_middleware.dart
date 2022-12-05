import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousListMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is! LoginSuccessState || action is! RendezvousListRequestAction) return;

    store.dispatch(RendezvousListLoadingAction(action.period));
    final result = await _repository.getRendezvousList(loginState.user.id, action.period);
    store.dispatch(
      result != null ? RendezvousListSuccessAction(result, action.period) : RendezvousListFailureAction(action.period),
    );
  }
}
