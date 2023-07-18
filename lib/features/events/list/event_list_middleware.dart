import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';
import 'package:redux/redux.dart';

class EventListMiddleware extends MiddlewareClass<AppState> {
  final AnimationsCollectivesRepository _animationsCollectivesRepository;

  EventListMiddleware(this._animationsCollectivesRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is EventListRequestAction) {
      store.dispatch(EventListLoadingAction());
      final animationsCollectives = await _animationsCollectivesRepository.get(userId, action.maintenant);
      if (animationsCollectives != null) {
        store.dispatch(EventListSuccessAction(animationsCollectives, []));
      } else {
        store.dispatch(EventListFailureAction());
      }
    }
  }
}
