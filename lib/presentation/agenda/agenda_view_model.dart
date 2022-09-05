import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/agenda.dart';
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

  AgendaPageViewModel(
      {required this.displayState, required this.events, required this.resetCreateAction, required this.retry});

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
  if (agendaState is AgendaFailureState) {
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

List<AgendaItem> _events(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is! AgendaSuccessState) return [];

  final events = _allEventsSorted(agendaState.agenda);

  return [
    if (agendaState.agenda.delayedActions > 0) DelayedActionsBanner(agendaState.agenda.delayedActions),
    _makeCurrentWeek(events, agendaState.agenda.dateDeDebut),
    _makeNextWeek(events, agendaState.agenda.dateDeDebut),
  ];
}

List<EventAgenda> _allEventsSorted(Agenda agenda) {
  final events = [
    ...agenda.actions.map((e) => UserActionEventAgenda(e.id, e.dateEcheance)),
    ...agenda.rendezvous.map((e) => RendezvousEventAgenda(e.id, e.date)),
  ];

  events.sort((a, b) => a.date.compareTo(b.date));

  return events;
}

CurrentWeekAgendaItem _makeCurrentWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final currentWeekEvents = events.where((element) => element.date.isBefore(nextWeekFirstDay));

  final eventsByDay = _sevenDaysMap(dateDeDebutAgenda);
  for (var event in currentWeekEvents) {
    (eventsByDay[event.date.toDayOfWeekWithFullMonth().firstLetterUpperCased()] ??= []).add(event);
  }

  final daySections = eventsByDay.keys.map((date) {
    final title = date;
    final events = eventsByDay[date]!.toList();
    return DaySectionAgenda(title, events);
  }).toList();

  return CurrentWeekAgendaItem(daySections);
}

Map<String, List<EventAgenda>> _sevenDaysMap(DateTime dateDeDebut) {
  final allOffsets = Iterable<int>.generate(7).toList();
  final allDates = allOffsets.map((offset) => dateDeDebut.add(Duration(days: offset)));
  final allDays = allDates.map((date) => date.toDayOfWeekWithFullMonth().firstLetterUpperCased());
  return {for (var day in allDays) day: <EventAgenda>[]};
}

NextWeekAgendaItem _makeNextWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final nextWeekEvents = events.where((element) => !element.date.isBefore(nextWeekFirstDay)).toList();
  return NextWeekAgendaItem(nextWeekEvents);
}

abstract class AgendaItem extends Equatable {}

// todo rename *AgendaItem
class DelayedActionsBanner extends AgendaItem {
  final int count;

  DelayedActionsBanner(this.count);

  @override
  List<Object?> get props => [count];
}

class CurrentWeekAgendaItem extends AgendaItem {
  final List<DaySectionAgenda> days;

  CurrentWeekAgendaItem(this.days);

  @override
  List<Object?> get props => [days];
}

class NextWeekAgendaItem extends AgendaItem {
  final List<EventAgenda> events;

  NextWeekAgendaItem(this.events);

  @override
  List<Object?> get props => [events];
}

class DaySectionAgenda extends Equatable {
  final String title;
  final List<EventAgenda> events;

  DaySectionAgenda(this.title, this.events);

  @override
  List<Object?> get props => [title, events];
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
