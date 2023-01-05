// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/agenda/agenda_actions.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/models/agenda.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:redux/redux.dart';

enum CreateButton { userAction, demarche }

class AgendaPageViewModel extends Equatable {
  final DisplayState displayState;
  final bool isPoleEmploi;
  final List<AgendaItem> events;
  final List<AgendaItem> events2;
  final String emptyMessage;
  final String noEventLabel;
  final CreateButton createButton;
  final Function() resetCreateAction;
  final Function(DateTime) reload;
  final Function() goToEventList;

  AgendaPageViewModel({
    required this.displayState,
    required this.isPoleEmploi,
    required this.events,
    required this.events2,
    required this.emptyMessage,
    required this.noEventLabel,
    required this.createButton,
    required this.resetCreateAction,
    required this.reload,
    required this.goToEventList,
  });

  factory AgendaPageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final isPoleEmploi = loginState is LoginSuccessState && loginState.user.loginMode.isPe();
    return AgendaPageViewModel(
      displayState: _displayState(store),
      isPoleEmploi: isPoleEmploi,
      events: _events(store, isPoleEmploi),
      events2: _events2(store, isPoleEmploi),
      emptyMessage: isPoleEmploi ? Strings.agendaEmptyPoleEmploi : Strings.agendaEmptyMilo,
      noEventLabel: isPoleEmploi ? Strings.agendaEmptyForDayPoleEmploi : Strings.agendaEmptyForDayMilo,
      createButton: isPoleEmploi ? CreateButton.demarche : CreateButton.userAction,
      resetCreateAction: () => store.dispatch(UserActionCreateResetAction()),
      reload: (date) => store.dispatch(AgendaRequestAction(date)),
      goToEventList: () => store.dispatch(LocalDeeplinkAction({"type": "EVENT_LIST"})),
    );
  }

  @override
  List<Object?> get props => [displayState, isPoleEmploi, events, events2, emptyMessage, noEventLabel, createButton];
}

DisplayState _displayState(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is AgendaFailureState) {
    return DisplayState.FAILURE;
  } else if (agendaState is AgendaSuccessState) {
    final agenda = agendaState.agenda;
    if (agenda.actions.isEmpty && agenda.demarches.isEmpty && agenda.rendezvous.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.LOADING;
}

List<AgendaItem> _events(Store<AppState> store, bool isPoleEmploi) {
  final agendaState = store.state.agendaState;
  if (agendaState is! AgendaSuccessState) return [];

  final events = _allEventsSorted(agendaState.agenda);
  final delayedActions = agendaState.agenda.delayedActions;

  return [
    if (delayedActions > 0)
      DelayedActionsBannerAgendaItem(
        isPoleEmploi ? Strings.numberOfDemarches(delayedActions) : Strings.numberOfActions(delayedActions),
      ),
    _makeCurrentWeek(events, agendaState.agenda.dateDeDebut),
    _makeNextWeek(events, agendaState.agenda.dateDeDebut),
  ];
}

List<AgendaItem> _events2(Store<AppState> store, bool isPoleEmploi) {
  final agendaState = store.state.agendaState;
  if (agendaState is! AgendaSuccessState) return [];

  final events = _allEventsSorted(agendaState.agenda);
  final delayedActions = agendaState.agenda.delayedActions;

  return [
    if (delayedActions > 0)
      DelayedActionsBannerAgendaItem(
        isPoleEmploi ? Strings.numberOfDemarches(delayedActions) : Strings.numberOfActions(delayedActions),
      ),
    ..._makeCurrentWeek2(events, agendaState.agenda.dateDeDebut),
    ..._makeNextWeek2(events, agendaState.agenda.dateDeDebut),
  ];
}

List<EventAgenda> _allEventsSorted(Agenda agenda) {
  final events = [
    ...agenda.actions.map((e) => UserActionEventAgenda(e.id, e.dateEcheance)),
    ...agenda.demarches.where((e) => e.endDate != null).map((e) => DemarcheEventAgenda(e.id, e.endDate!)),
    ...agenda.rendezvous.map((e) => RendezvousEventAgenda(e.id, e.date)),
  ];

  events.sort((a, b) => a.date.compareTo(b.date));

  return events;
}

CurrentWeekAgendaItem _makeCurrentWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final currentWeekEvents = events.where((element) => element.date.isBefore(nextWeekFirstDay));

  if (currentWeekEvents.isEmpty) {
    return CurrentWeekAgendaItem([]);
  }

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

List<AgendaItem> _makeCurrentWeek2(List<EventAgenda> events, DateTime dateDeDebutAgenda) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final currentWeekEvents = events.where((element) => element.date.isBefore(nextWeekFirstDay));

  if (currentWeekEvents.isEmpty) {
    return [
      WeekSeparatorAgendaItem("Semaine en cours"), // FIXME: Strings
      EmptyMessageAgendaItem(),
    ];
  } else {
    final eventsByDay = _sevenDaysMap(dateDeDebutAgenda);
    for (var event in currentWeekEvents) {
      (eventsByDay[event.date.toDayOfWeekWithFullMonth().firstLetterUpperCased()] ??= []).add(event);
    }

    final List<AgendaItem> currentWeekItems = [];
    for (var entry in eventsByDay.entries) {
      currentWeekItems.add(DaySeparatorAgendaItem(entry.key));
      if (entry.value.isEmpty) {
        currentWeekItems.add(EmptyMessageAgendaItem());
      } else {
        for (var event in entry.value) {
          switch (event.runtimeType) {
            case UserActionEventAgenda:
              currentWeekItems.add(UserActionAgendaItem(event.id));
              break;
            case DemarcheEventAgenda:
              currentWeekItems.add(DemarcheAgendaItem(event.id));
              break;
            case RendezvousEventAgenda:
              currentWeekItems.add(RendezvousAgendaItem(event.id));
              break;
          }
        }
      }
    }
    return currentWeekItems;
  }
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

List<AgendaItem> _makeNextWeek2(List<EventAgenda> events, DateTime dateDeDebutAgenda) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final nextWeekEvents = events.where((element) => !element.date.isBefore(nextWeekFirstDay)).toList();
  if (nextWeekEvents.isEmpty) {
    return [
      WeekSeparatorAgendaItem("Semaine prochaine"),
      EmptyMessageAgendaItem(),
    ];
  } else {
    final nextWeekAgendaItems = nextWeekEvents
        .map((e) {
          switch (e.runtimeType) {
            case UserActionEventAgenda:
              return UserActionAgendaItem(e.id, collapsed: true);
            case DemarcheEventAgenda:
              return DemarcheAgendaItem(e.id, collapsed: true);
            case RendezvousEventAgenda:
              return RendezvousAgendaItem(e.id, collapsed: true);
          }
        })
        .whereType<AgendaItem>()
        .toList();
    return [
      WeekSeparatorAgendaItem("Semaine prochaine"),
      ...nextWeekAgendaItems,
    ];
  }
}

abstract class AgendaItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class DelayedActionsBannerAgendaItem extends AgendaItem {
  final String delayedLabel;

  DelayedActionsBannerAgendaItem(this.delayedLabel);

  @override
  List<Object?> get props => [delayedLabel];
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

class WeekSeparatorAgendaItem extends AgendaItem {
  final String text;

  WeekSeparatorAgendaItem(this.text);

  @override
  List<Object?> get props => [text];
}

class DaySeparatorAgendaItem extends AgendaItem {
  final String text;

  DaySeparatorAgendaItem(this.text);

  @override
  List<Object?> get props => [text];
}

class EmptyMessageAgendaItem extends AgendaItem {}

class RendezvousAgendaItem extends AgendaItem {
  final String rendezvousId;
  final bool collapsed;

  RendezvousAgendaItem(this.rendezvousId, {this.collapsed = false});

  @override
  List<Object?> get props => [rendezvousId, collapsed];
}

class DemarcheAgendaItem extends AgendaItem {
  final String demarcheId;
  final bool collapsed;

  DemarcheAgendaItem(this.demarcheId, {this.collapsed = false});

  @override
  List<Object?> get props => [demarcheId, collapsed];
}

class UserActionAgendaItem extends AgendaItem {
  final String actionId;
  final bool collapsed;

  UserActionAgendaItem(this.actionId, {this.collapsed = false});

  @override
  List<Object?> get props => [actionId, collapsed];
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

class DemarcheEventAgenda extends EventAgenda {
  DemarcheEventAgenda(super.id, super.date);
}

class RendezvousEventAgenda extends EventAgenda {
  RendezvousEventAgenda(super.id, super.date);
}
