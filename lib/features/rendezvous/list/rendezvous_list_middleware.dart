import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/models/rendezvous_list_result.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/rendezvous/rendezvous_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:redux/redux.dart';

class RendezvousListMiddleware extends MiddlewareClass<AppState> {
  final RendezvousRepository _rendezvousRepository;
  final SessionMiloRepository _sessionMiloRepository;

  RendezvousListMiddleware(this._rendezvousRepository, this._sessionMiloRepository);

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

      final (rendezvousListResult, sessionsMilo) = await _fetch(userId, period);

      if (rendezvousListResult != null && sessionsMilo != null) {
        store.dispatch(RendezvousListSuccessAction(
          rendezvousListResult: rendezvousListResult,
          sessionsMilo: sessionsMilo,
          period: period,
        ));
      } else {
        store.dispatch(RendezvousListFailureAction(period));
      }
    }
    return;
  }

  Future<(RendezvousListResult?, List<SessionMilo>?)> _fetch(String userId, RendezvousPeriod period) async {
    late RendezvousListResult? rendezvousListResult;
    late List<SessionMilo>? sessionsMilo;

    final Future<List<SessionMilo>?> fetchSessions = //
        period == RendezvousPeriod.FUTUR //
            ? _sessionMiloRepository.getList(userId)
            : Future.value([]);

    await Future.wait([
      _rendezvousRepository.getRendezvousList(userId, period).then((result) => rendezvousListResult = result),
      fetchSessions.then((result) => sessionsMilo = result),
    ]);

    return (rendezvousListResult, sessionsMilo);
  }
}
