import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _repository;

  RendezvousDetailsMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final user = store.state.user();
    if (user == null) return;
    if (action is RendezvousDetailsRequestAction) {
      store.dispatch(RendezvousDetailsLoadingAction());
      final rdv = await getRendezvous(user.loginMode, user.id, action.rendezvousId);
      store.dispatch(rdv != null ? RendezvousDetailsSuccessAction(rdv) : RendezvousDetailsFailureAction());
    }
  }

  Future<Rendezvous?> getRendezvous(LoginMode loginMode, String userId, String rendezvousId) async {
    return loginMode == LoginMode.POLE_EMPLOI
        ? await _repository.getRendezvousPoleEmploi(userId, rendezvousId)
        : await _repository.getRendezvousMilo(userId, rendezvousId);
  }
}
