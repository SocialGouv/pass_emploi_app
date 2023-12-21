import 'package:collection/collection.dart';
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
      onRetry: () => {store.dispatch(EventListRequestAction(DateTime.now(), forceRefresh: true))},
    );
  }

  @override
  List<Object?> get props => [displayState, eventIds];
}

DisplayState _displayState(EventListState eventListState) {
  if (eventListState is EventListFailureState) {
    return DisplayState.erreur;
  } else if (eventListState is EventListSuccessState) {
    if (eventListState.animationsCollectives.isEmpty && eventListState.sessionsMilos.isEmpty) {
      return DisplayState.vide;
    } else {
      return DisplayState.contenu;
    }
  }
  return DisplayState.chargement;
}

List<EventId> _eventIds(EventListState eventListState) {
  if (eventListState is! EventListSuccessState) {
    return [];
  }

  return [
    ...eventListState.animationsCollectives.map((e) => (AnimationCollectiveId(e.id), e.date)),
    ...eventListState.sessionsMilos.map((e) => (SessionMiloId(e.id), e.dateDeDebut)),
  ].sortedBy((e) => e.$2).map((e) => e.$1).toList();
}
