import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/event_list_repository.dart';
import 'package:redux/redux.dart';

class EventListMiddleware extends MiddlewareClass<AppState> {
  final EventListRepository _repository;

  EventListMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final userId = store.state.userId();
    if (userId != null && action is EventListRequestAction) {
      store.dispatch(EventListLoadingAction());
      final rendezvous = await _repository.get(userId);
      if (rendezvous != null) {
        store.dispatch(EventListSuccessAction(rendezvous));
      } else {
        store.dispatch(EventListFailureAction());
      }
    }
  }
}
