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
  final String noEventLabel;
  final CreateButton createButton;
  final Function() resetCreateAction;
  final Function(DateTime) reload;
  final Function() goToEventList;

  AgendaPageViewModel({
    required this.displayState,
    required this.isPoleEmploi,
    required this.events,
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
      emptyMessage: isPoleEmploi ? Strings.agendaEmptyPoleEmploi : Strings.agendaEmptyMilo,
      noEventLabel: isPoleEmploi ? Strings.agendaEmptyForDayPoleEmploi : Strings.agendaEmptyForDayMilo,
      createButton: isPoleEmploi ? CreateButton.demarche : CreateButton.userAction,
      resetCreateAction: () => store.dispatch(UserActionCreateResetAction()),
      reload: (date) => store.dispatch(AgendaRequestAction(date)),
      goToEventList: () => store.dispatch(LocalDeeplinkAction({"type": "EVENT_LIST"})),
    );
  }

  @override
  List<Object?> get props => [displayState, isPoleEmploi, events, emptyMessage, noEventLabel, createButton];
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
    _makeCurrentWeek(events, agendaState.agenda.dateDeDebut, isPoleEmploi),
    _makeNextWeek(events, agendaState.agenda.dateDeDebut),
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

CurrentWeekAgendaItem _makeCurrentWeek(List<EventAgenda> events, DateTime dateDeDebutAgenda, bool isPoleEmploi) {
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

  if (!isPoleEmploi) daySections.removeWeekendIfNoEvent(dateDeDebutAgenda);

  return CurrentWeekAgendaItem(daySections);
}

extension _ListDaySectionAgendaExt on List<DaySectionAgenda> {
  void removeWeekendIfNoEvent(DateTime dateDeDebutAgenda) {
    if (dateDeDebutAgenda.isSaturday() == false) return;

    final saturdayEvents = this[0].events;
    final sundayEvents = this[1].events;

    if (saturdayEvents.isEmpty && sundayEvents.isEmpty) {
      removeAt(0);
      removeAt(0);
    } else if (saturdayEvents.isEmpty) {
      removeAt(0);
    }
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

abstract class AgendaItem extends Equatable {}

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
