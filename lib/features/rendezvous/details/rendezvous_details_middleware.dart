import 'package:collection/collection.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
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
      final rdv = user.loginMode == LoginMode.POLE_EMPLOI
          ? await getRendezvousPoleEmploi(user.id, action.rendezvousId)
          : await getRendezvousMilo(user.id, action.rendezvousId);
      store.dispatch(rdv != null ? RendezvousDetailsSuccessAction(rdv) : RendezvousDetailsFailureAction());
    }
  }

  Future<Rendezvous?> getRendezvousPoleEmploi(String userId, String rendezvousId) async {
    final rdvs = await _repository.getRendezvousList(userId, RendezvousPeriod.FUTUR);
    return rdvs?.rendezvous.firstWhereOrNull((rdv) => rdv.id == rendezvousId);
  }

  Future<Rendezvous?> getRendezvousMilo(String userId, String rendezvousId) async {
    return _repository.getRendezvousMilo(userId, rendezvousId);
  }
}
