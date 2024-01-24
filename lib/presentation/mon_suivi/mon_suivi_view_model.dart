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
  final int indexOfTodayItem;
  final bool withCreateButton;
  final Function() onLoadPreviousPeriod;
  final Function() onLoadNextPeriod;
  final Function() onRetry;

  MonSuiviViewModel._({
    required this.displayState,
    required this.items,
    required this.indexOfTodayItem,
    required this.withCreateButton,
    required this.onLoadPreviousPeriod,
    required this.onLoadNextPeriod,
    required this.onRetry,
  });

  factory MonSuiviViewModel.create(Store<AppState> store) {
    final state = store.state.monSuiviState;
    final items = _items(state);
    return MonSuiviViewModel._(
      displayState: _displayState(state),
      items: items,
      indexOfTodayItem: items.indexWhere((e) => e is DayMonSuiviItem && e.isToday),
      withCreateButton: state is MonSuiviSuccessState,
      onLoadPreviousPeriod: () => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.previous)),
      onLoadNextPeriod: () => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.next)),
      onRetry: () => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current)),
    );
  }

  @override
  List<Object?> get props => [displayState, items, indexOfTodayItem, withCreateButton];
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
    final day = MonSuiviDay.fromDateTime(jourCourant);
    final isToday = jourCourant.isToday();
    items.add(
      entries != null ? FilledDayMonSuiviItem(day, entries, isToday) : EmptyDayMonSuiviItem(day, isToday),
    );

    jourCourant = jourCourant.add(Duration(days: 1));
  }
  return items;
}

SemaineSectionMonSuiviItem _semaineSectionItem(DateTime jourCourant) {
  String? boldTitle;
  if (jourCourant.isAtSameWeekAs(clock.now())) {
    boldTitle = Strings.monSuiviCetteSemaine;
  } else if (jourCourant.isAtSameWeekAs(clock.now().add(Duration(days: 7)))) {
    boldTitle = Strings.monSuiviSemaineProchaine;
  }
  return SemaineSectionMonSuiviItem(_semaineInterval(jourCourant), boldTitle);
}

String _semaineInterval(DateTime monday) {
  final sunday = monday.add(Duration(days: 6));
  return "${monday.day} - ${sunday.day} ${sunday.toMonth()} ${sunday.year}";
}

Map<DateTime, List<MonSuiviEntry>> _entriesByDay(MonSuiviState state) {
  if (state is! MonSuiviSuccessState) return {};
  final entriesByDay = <DateTime, List<MonSuiviEntry>>{};
  for (var action in state.monSuivi.actions) {
    entriesByDay.add(action.dateEcheance, UserActionMonSuiviEntry(action.id));
  }
  for (var rdv in state.monSuivi.rendezvous) {
    entriesByDay.add(rdv.date, RendezvousMonSuiviEntry(rdv.id));
  }
  for (var session in state.monSuivi.sessionsMilo) {
    entriesByDay.add(session.dateDeDebut, SessionMiloMonSuiviEntry(session.id));
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

class SemaineSectionMonSuiviItem extends MonSuiviItem {
  final String interval;
  final String? boldTitle;

  SemaineSectionMonSuiviItem(this.interval, [this.boldTitle]);

  @override
  List<Object?> get props => [interval, boldTitle];
}

sealed class DayMonSuiviItem extends MonSuiviItem {
  final MonSuiviDay day;
  final bool isToday;

  DayMonSuiviItem(this.day, this.isToday);
}

class FilledDayMonSuiviItem extends DayMonSuiviItem {
  final List<MonSuiviEntry> entries;

  FilledDayMonSuiviItem(super.day, this.entries, [super.isToday = false]);

  @override
  List<Object?> get props => [day, isToday, entries];
}

class EmptyDayMonSuiviItem extends DayMonSuiviItem {
  EmptyDayMonSuiviItem(super.day, [super.isToday = false]);

  @override
  List<Object?> get props => [day, isToday];
}

class MonSuiviDay extends Equatable {
  final String shortened;
  final String number;

  MonSuiviDay(this.shortened, this.number);

  factory MonSuiviDay.fromDateTime(DateTime dateTime) => MonSuiviDay(
        dateTime.toDayShortened(),
        dateTime.day.toString(),
      );

  @override
  List<Object?> get props => [shortened, number];
}

sealed class MonSuiviEntry extends Equatable {}

class UserActionMonSuiviEntry extends MonSuiviEntry {
  final String id;

  UserActionMonSuiviEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class RendezvousMonSuiviEntry extends MonSuiviEntry {
  final String id;

  RendezvousMonSuiviEntry(this.id);

  @override
  List<Object?> get props => [id];
}

class SessionMiloMonSuiviEntry extends MonSuiviEntry {
  final String id;

  SessionMiloMonSuiviEntry(this.id);

  @override
  List<Object?> get props => [id];
}
