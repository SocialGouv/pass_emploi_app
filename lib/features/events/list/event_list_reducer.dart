import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';

EventListState eventListReducer(EventListState current, dynamic action) {
  if (action is EventListLoadingAction) return EventListLoadingState();
  if (action is EventListFailureAction) return EventListFailureState();
  if (action is EventListSuccessAction) {
    return EventListSuccessState(
      action.events,
      action.sessionsMilos,
    );
  }
  return current;
}
