import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class EventListPageViewModel extends Equatable {
  final DisplayState displayState;

  EventListPageViewModel({
    required this.displayState,
  });

  factory EventListPageViewModel.create(Store<AppState> store) {
    final eventListState = store.state.eventListState;
    return EventListPageViewModel(
      displayState: _displayState(eventListState),
    );
  }

  @override
  List<Object?> get props => [];
}

DisplayState _displayState(EventListState eventListState) {
  if (eventListState is EventListFailureState) {
    return DisplayState.FAILURE;
  } else if (eventListState is EventListSuccessState) {
    if (eventListState.rendezvous.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.LOADING;
}
