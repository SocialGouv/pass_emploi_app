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
  final String emptyMessage;
  final CreateButton createButton;
  final bool isReloading;
  final Function() resetCreateAction;
  final Function(DateTime) reload;
  final Function() goToEventList;

  AgendaPageViewModel({
    required this.displayState,
    required this.isPoleEmploi,
    required this.events,
    required this.emptyMessage,
    required this.createButton,
    required this.isReloading,
    required this.resetCreateAction,
    required this.reload,
    required this.goToEventList,
  });

  factory AgendaPageViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final isPoleEmploi = loginState is LoginSuccessState && loginState.user.loginMode.isPe();
    return AgendaPageViewModel(
      displayState: _displayState(store, isPoleEmploi),
      isPoleEmploi: isPoleEmploi,
      events: _events(store, isPoleEmploi),
      emptyMessage: isPoleEmploi ? Strings.agendaEmptyPoleEmploi : Strings.agendaEmptyMilo,
      createButton: isPoleEmploi ? CreateButton.demarche : CreateButton.userAction,
      isReloading: store.state.agendaState is AgendaReloadingState,
      resetCreateAction: () => store.dispatch(UserActionCreateResetAction()),
      reload: (date) => store.dispatch(AgendaRequestReloadAction(date)),
      goToEventList: () => store.dispatch(LocalDeeplinkAction({"type": "EVENT_LIST"})),
    );
  }

  @override
  List<Object?> get props => [displayState, isPoleEmploi, events, emptyMessage, createButton, isReloading];
}

DisplayState _displayState(Store<AppState> store, bool isPoleEmploi) {
  final agendaState = store.state.agendaState;
  if (agendaState is AgendaFailureState) {
    return DisplayState.FAILURE;
  } else if (agendaState is AgendaSuccessState) {
    final agenda = agendaState.agenda;
    if (agenda.actions.isEmpty && agenda.demarches.isEmpty && agenda.rendezvous.isEmpty && isPoleEmploi) {
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

  if (!isPoleEmploi && events.isEmpty) {
    return [
      if (delayedActions > 0) DelayedActionsBannerAgendaItem(Strings.numberOfActions(delayedActions)),
      CallToActionEventMiloAgendaItem()
    ];
  }

  return [
    if (agendaState.agenda.dateDerniereMiseAJour != null) NotUpToDateAgendaItem(),
    if (delayedActions > 0)
      DelayedActionsBannerAgendaItem(
        isPoleEmploi ? Strings.numberOfDemarches(delayedActions) : Strings.numberOfActions(delayedActions),
      ),
    ..._makeCurrentWeek(events, agendaState.agenda.dateDeDebut, isPoleEmploi),
    ..._makeNextWeek(events, agendaState.agenda.dateDeDebut, isPoleEmploi),
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

EmptyMessageAgendaItem _makeEmptyMessage(bool isPoleEmploi) {
  return EmptyMessageAgendaItem(isPoleEmploi ? Strings.agendaEmptyForDayPoleEmploi : Strings.agendaEmptyForDayMilo);
}

List<AgendaItem> _makeCurrentWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda, bool isPoleEmploi) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final currentWeekEvents = events.where((element) => element.date.isBefore(nextWeekFirstDay));

  if (currentWeekEvents.isEmpty && isPoleEmploi) {
    return [
      WeekSeparatorAgendaItem(Strings.semaineEnCours),
      _makeEmptyMessage(isPoleEmploi),
    ];
  } else if (currentWeekEvents.isEmpty && !isPoleEmploi) {
    return [CallToActionEventMiloAgendaItem()];
  } else {
    return _makeCurrentWeekWithEvents(currentWeekEvents, dateDeDebutAgenda, isPoleEmploi);
  }
}

List<AgendaItem> _makeCurrentWeekWithEvents(
  Iterable<EventAgenda> currentWeekEvents,
  DateTime dateDeDebutAgenda,
  bool isPoleEmploi,
) {
  final eventsByDay = _sevenDaysMap(dateDeDebutAgenda);
  for (var event in currentWeekEvents) {
    (eventsByDay[event.date.toDayOfWeekWithFullMonth().firstLetterUpperCased()] ??= []).add(event);
  }

  final List<AgendaItem> currentWeekItems = [];
  for (var entry in eventsByDay.entries) {
    currentWeekItems.add(DaySeparatorAgendaItem(entry.key));
    if (entry.value.isEmpty) {
      currentWeekItems.add(_makeEmptyMessage(isPoleEmploi));
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

Map<String, List<EventAgenda>> _sevenDaysMap(DateTime dateDeDebut) {
  final allOffsets = Iterable<int>.generate(7).toList();
  final allDates = allOffsets.map((offset) => dateDeDebut.add(Duration(days: offset)));
  final allDays = allDates.map((date) => date.toDayOfWeekWithFullMonth().firstLetterUpperCased());
  return {for (var day in allDays) day: <EventAgenda>[]};
}

List<AgendaItem> _makeNextWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda, bool isPoleEmploi) {
  final nextWeekFirstDay = dateDeDebutAgenda.addWeeks(1);
  final nextWeekEvents = events.where((element) => !element.date.isBefore(nextWeekFirstDay)).toList();
  if (nextWeekEvents.isEmpty) {
    return [
      WeekSeparatorAgendaItem(Strings.nextWeek),
      _makeEmptyMessage(isPoleEmploi),
    ];
  } else {
    return _makeNextWeekWithEvents(nextWeekEvents);
  }
}

List<AgendaItem> _makeNextWeekWithEvents(List<EventAgenda> nextWeekEvents) {
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
    WeekSeparatorAgendaItem(Strings.nextWeek),
    ...nextWeekAgendaItems,
  ];
}

abstract class AgendaItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotUpToDateAgendaItem extends AgendaItem {}

class DelayedActionsBannerAgendaItem extends AgendaItem {
  final String delayedLabel;

  DelayedActionsBannerAgendaItem(this.delayedLabel);

  @override
  List<Object?> get props => [delayedLabel];
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

class EmptyMessageAgendaItem extends AgendaItem {
  final String text;
  EmptyMessageAgendaItem(this.text);

  @override
  List<Object?> get props => [text];
}

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

class CallToActionEventMiloAgendaItem extends AgendaItem {}

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
