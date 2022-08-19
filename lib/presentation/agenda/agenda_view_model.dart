import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

class AgendaPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<AgendaItem> events;
  final Function() resetCreateAction;
  final Function(DateTime) retry;

  AgendaPageViewModel({required this.displayState, required this.events, required this.resetCreateAction, required this.retry});

  factory AgendaPageViewModel.create(Store<AppState> store) {
    return AgendaPageViewModel(
      displayState: _displayState(store),
      events: _events(store),
      resetCreateAction: () => store.dispatch(UserActionCreateResetAction()),
      retry: (date) => store.dispatch(AgendaRequestAction(date)),
    );
  }

  @override
  List<Object?> get props => [displayState, events];
}

DisplayState _displayState(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is AgendaLoadingState) {
    return DisplayState.LOADING;
  } else if (agendaState is AgendaFailureState) {
  final agendaState = store.state.agendaState;
  if (agendaState is AgendaFailureState) {
    return DisplayState.FAILURE;
  } else if (agendaState is AgendaSuccessState) {
    if (agendaState.agenda.actions.isEmpty && agendaState.agenda.rendezvous.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.FAILURE;
  } else if (agendaState is AgendaSuccessState) {
    if (agendaState.agenda.actions.isEmpty && agendaState.agenda.rendezvous.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.LOADING;
}

// todo peut-être un refactoring avec plusieurs fonctions à extraire
List<AgendaItem> _events(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is! AgendaSuccessState) return [];

  final events = [
    ...agendaState.agenda.actions.map((e) => UserActionEventAgenda(e.id, e.dateEcheance)),
    ...agendaState.agenda.rendezvous.map((e) => RendezvousEventAgenda(e.id, e.date)),
  ];

  events.sort((a, b) => a.date.compareTo(b.date));

  final grouped = events.groupListsBy((element) => element.date.toDayOfWeekWithFullMonth().firstLetterUpperCased());
  final keys = grouped.keys.toList();

  final daySections = keys.map((date) {
    final title = date;
    final events = grouped[date]!.toList();
    return DaySectionAgenda(title, events);
  }).toList();

  return [
    if (agendaState.agenda.delayedActions > 0) DelayedActionsBanner(agendaState.agenda.delayedActions),
    ...daySections,
  ];
}

abstract class EventAgenda extends Equatable {
  final String id;
  final DateTime date;

  EventAgenda(this.id, this.date);

  @override
  List<Object?> get props => [id, date];
}

class UserActionEventAgenda extends EventAgenda {
  UserActionEventAgenda(super.id, super.date);
}

class RendezvousEventAgenda extends EventAgenda {
  RendezvousEventAgenda(super.id, super.date);
}

abstract class AgendaItem extends Equatable {}

class DaySectionAgenda extends AgendaItem {
  final String title;
  final List<EventAgenda> events;

  DaySectionAgenda(this.title, this.events);

  @override
  List<Object?> get props => [title, events];
}
class DelayedActionsBanner extends AgendaItem {
  final int count;

  DelayedActionsBanner(this.count);

  @override
  List<Object?> get props => [count];
}
