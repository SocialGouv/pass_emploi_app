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

    final userId = store.state.userId();
    if (userId == null) return;

    if (action is RendezvousListRequestAction || action is RendezvousListRequestReloadAction) {
      final period = action.period as RendezvousPeriod;
      store.dispatch(action is RendezvousListRequestAction
          ? RendezvousListLoadingAction(period)
          : RendezvousListReloadingAction(period));
      final result = await _repository.getRendezvousList(userId, period);
      store.dispatch(result != null
          ? RendezvousListSuccessAction(result, period) //
          : RendezvousListFailureAction(period));
    }
    return;
  }
}
