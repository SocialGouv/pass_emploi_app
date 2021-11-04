import 'package:pass_emploi_app/redux/actions/rendezvous_actions.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestRendezvousAction) {
      store.dispatch(RendezvousLoadingAction());
      final rendezvous = await _repository.getRendezvous(action.userId);
      store.dispatch(rendezvous != null ? RendezvousSuccessAction(rendezvous) : RendezvousFailureAction());
    }
  }
}
