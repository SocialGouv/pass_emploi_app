import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

sealed class EventId extends Equatable {
  final String id;
  EventId(this.id);

  @override
  List<Object?> get props => [id];
}

class AnimationCollectiveId extends EventId {
  AnimationCollectiveId(super.id);
}

class SessionMiloId extends EventId {
  SessionMiloId(super.id);
}

class EventListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<EventId> eventIds;
  final Function onRetry;

  EventListPageViewModel({
    required this.displayState,
    required this.eventIds,
    required this.onRetry,
  });

  factory EventListPageViewModel.create(Store<AppState> store) {
    final eventListState = store.state.eventListState;
    return EventListPageViewModel(
      displayState: _displayState(eventListState),
      eventIds: _eventIds(eventListState),
      onRetry: () => {store.dispatch(EventListRequestAction(DateTime.now()))},
    );
  }

  @override
  List<Object?> get props => [displayState, eventIds];
}

DisplayState _displayState(EventListState eventListState) {
  if (eventListState is EventListFailureState) {
    return DisplayState.FAILURE;
  } else if (eventListState is EventListSuccessState) {
    if (eventListState.events.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.LOADING;
}

List<EventId> _eventIds(EventListState eventListState) {
  if (eventListState is! EventListSuccessState) {
    return [];
  }
  return eventListState.events.map((e) => AnimationCollectiveId(e.id)).toList();
}
