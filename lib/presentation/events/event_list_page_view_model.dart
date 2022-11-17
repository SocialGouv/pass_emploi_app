import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EventListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<String> events;

  EventListPageViewModel({
    required this.displayState,
    required this.events,
  });

  factory EventListPageViewModel.create(Store<AppState> store) {
    final eventListState = store.state.eventListState;
    return EventListPageViewModel(
      displayState: _displayState(eventListState),
      events: _events(eventListState),
    );
  }

  @override
  List<Object?> get props => [displayState, events];
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

List<String> _events(EventListState eventListState) {
  if (eventListState is! EventListSuccessState) {
    return [];
  }
  return eventListState.events.map((e) => e.id).toList();
}
