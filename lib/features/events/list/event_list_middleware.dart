import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';
import 'package:redux/redux.dart';

class EventListMiddleware extends MiddlewareClass<AppState> {
  final AnimationsCollectivesRepository _animationsCollectivesRepository;
  final SessionMiloRepository _sessionMiloRepository;

  EventListMiddleware(this._animationsCollectivesRepository, this._sessionMiloRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final user = store.state.user();
    if (user == null) return;

    if (action is EventListRequestAction) {
      store.dispatch(EventListLoadingAction());
      final (animations, sessions) = await _fetch(user.loginMode, user.id, action.maintenant);
      if (animations != null || sessions != null) {
        store.dispatch(EventListSuccessAction(animations ?? [], sessions ?? []));
      } else {
        store.dispatch(EventListFailureAction());
      }
    }
  }

  Future<(List<Rendezvous>?, List<SessionMilo>?)> _fetch(
    LoginMode loginMode,
    String userId,
    DateTime maintenant,
  ) async {
    late List<Rendezvous>? animations;
    late List<SessionMilo>? sessionsMilo;

    final Future<List<SessionMilo>?> fetchSessions = //
        _shouldFetchSessions(loginMode) //
            ? _sessionMiloRepository.getList(userId: userId)
            : Future.value([]);

    await Future.wait([
      _animationsCollectivesRepository.get(userId, maintenant).then((result) => animations = result),
      fetchSessions.then((result) => sessionsMilo = result),
    ]);

    return (animations, sessionsMilo);
  }

  bool _shouldFetchSessions(LoginMode loginMode) {
    return loginMode.isMiLo();
  }
}
