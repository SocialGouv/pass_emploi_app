import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/actions/actions.dart';
import 'package:pass_emploi_app/redux/requests/rendezvous_request.dart';
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
    if (action is RequestAction<RendezvousRequest, List<Rendezvous>>) {
      final loginState = store.state.loginState;
      if (loginState is LoggedInState) {
        store.dispatch(LoadingAction<RendezvousRequest, List<Rendezvous>>());
        final rendezvous = await _repository.getRendezvous(loginState.user.id);
        store.dispatch(rendezvous != null
            ? SuccessAction<RendezvousRequest, List<Rendezvous>>(rendezvous)
            : FailureAction<RendezvousRequest, List<Rendezvous>>());
      }
    }
  }
}
