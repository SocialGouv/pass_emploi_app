import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_actions.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class MonSuiviViewModel extends Equatable {
  final DisplayState displayState;
  final List<MonSuiviItem> items;
  final Function() onRetry;

  MonSuiviViewModel._({required this.displayState, required this.items, required this.onRetry});

  factory MonSuiviViewModel.create(Store<AppState> store) {
    final state = store.state.monSuiviState;
    return MonSuiviViewModel._(
      displayState: _displayState(state),
      items: _items(state),
      onRetry: () => store.dispatch(MonSuiviRequestAction(Period.current)),
    );
  }

  @override
  List<Object?> get props => [displayState, items];
}

DisplayState _displayState(MonSuiviState state) {
  return switch (state) {
    MonSuiviNotInitializedState() => DisplayState.LOADING,
    MonSuiviLoadingState() => DisplayState.LOADING,
    MonSuiviFailureState() => DisplayState.FAILURE,
    MonSuiviSuccessState() => DisplayState.CONTENT,
  };
}

List<MonSuiviItem> _items(MonSuiviState state) {
  if (state is! MonSuiviSuccessState) return [];
  final entriesByDay = _entriesByDay(state);
  DateTime jourCourant = state.interval.debut.toStartOfDay();
  final items = <MonSuiviItem>[];
  while (jourCourant.isBefore(state.interval.fin)) {
    if (jourCourant.weekday == DateTime.monday) {
      items.add(_semaineSectionItem(jourCourant));
    }

    final entries = entriesByDay[jourCourant];
    final day = Day.fromDateTime(jourCourant);
    items.add(entries != null ? DayItem(day, entries) : EmptyDayItem(day));

    jourCourant = jourCourant.add(Duration(days: 1));
  }
  return items;
}

SemaineSectionItem _semaineSectionItem(DateTime jourCourant) {
  String? boldTitle;
  if (jourCourant.isAtSameWeekAs(clock.now())) {
    boldTitle = Strings.monSuiviCetteSemaine;
  } else if (jourCourant.isAtSameWeekAs(clock.now().add(Duration(days: 7)))) {
    boldTitle = Strings.monSuiviSemaineProchaine;
  }
  return SemaineSectionItem(_semaineInterval(jourCourant), boldTitle);
}

String _semaineInterval(DateTime monday) {
  return "${monday.day} - ${monday.day + 6} ${monday.toMonth()} ${monday.year}";
}

Map<DateTime, List<MonSuiviEntry>> _entriesByDay(MonSuiviState state) {
  if (state is! MonSuiviSuccessState) return {};
  final entriesByDay = <DateTime, List<MonSuiviEntry>>{};
  for (var action in state.monSuivi.actions) {
    entriesByDay.add(action.dateEcheance, UserActionEntry(action.id));
  }
  for (var rdv in state.monSuivi.rendezvous) {
    entriesByDay.add(rdv.date, RendezvousEntry(rdv.id));
  }
  for (var session in state.monSuivi.sessionsMilo) {
    entriesByDay.add(session.dateDeDebut, SessionMiloEntry(session.id));
  }
  return entriesByDay;
}

extension on Map<DateTime, List<MonSuiviEntry>> {
  void add(DateTime date, MonSuiviEntry entry) {
    putIfAbsent(date.toStartOfDay(), () => []);
    this[date.toStartOfDay()]!.add(entry);
  }
}

sealed class MonSuiviItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class SemaineSectionItem extends MonSuiviItem {
  final String interval;
  final String? boldTitle;

  SemaineSectionItem(this.interval, [this.boldTitle]);

  @override
  List<Object?> get props => [interval, boldTitle];
}

class DayItem extends MonSuiviItem {
  final Day day;
  final List<MonSuiviEntry> entries;

  DayItem(this.day, this.entries);

  @override
  List<Object?> get props => [day, entries];
}

class EmptyDayItem extends MonSuiviItem {
  final Day day;

  EmptyDayItem(this.day);

  @override
  List<Object?> get props => [day];
}

class Day extends Equatable {
  final String shortened;
  final String number;

  Day(this.shortened, this.number);

  factory Day.fromDateTime(DateTime dateTime) => Day(dateTime.toDayShortened(), dateTime.day.toString());

  @override
  List<Object?> get props => [shortened, number];
}

sealed class MonSuiviEntry extends Equatable {}

class UserActionEntry extends MonSuiviEntry {
  final String id;

  UserActionEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class RendezvousEntry extends MonSuiviEntry {
  final String id;

  RendezvousEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class SessionMiloEntry extends MonSuiviEntry {
  final String id;

  SessionMiloEntry(this.id);

  @override
  List<Object?> get props => [id];
}
