import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
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
  final bool withWarningOnWrongSessionMiloRetrieval;
  final int pendingActionCreations;
  final bool withPagination;
  final bool shouldShowOnboarding;
  final Function() onLoadPreviousPeriod;
  final Function() onLoadNextPeriod;
  final Function() onRetry;

  MonSuiviViewModel._({
    required this.displayState,
    required this.items,
    required this.indexOfTodayItem,
    required this.withCreateButton,
    required this.withWarningOnWrongSessionMiloRetrieval,
    required this.pendingActionCreations,
    required this.withPagination,
    required this.shouldShowOnboarding,
    required this.onLoadPreviousPeriod,
    required this.onLoadNextPeriod,
    required this.onRetry,
  });

  factory MonSuiviViewModel.create(Store<AppState> store) {
    final state = store.state.monSuiviState;
    final items = _items(store);
    return MonSuiviViewModel._(
      displayState: _displayState(state),
      items: items,
      indexOfTodayItem: items.indexWhere((e) => e is DayMonSuiviItem && e.isToday),
      withCreateButton: state is MonSuiviSuccessState,
      withWarningOnWrongSessionMiloRetrieval: _withWarningOnWrongSessionMiloRetrieval(state),
      pendingActionCreations: store.state.userActionCreatePendingState.getPendingCreationsCount(),
      withPagination: store.state.isMiloLoginMode(),
      shouldShowOnboarding: _shouldShowOnboarding(store),
      onLoadPreviousPeriod: () => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.previous)),
      onLoadNextPeriod: () => store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.next)),
      onRetry: () {
        store.dispatch(MonSuiviResetAction());
        store.dispatch(MonSuiviRequestAction(MonSuiviPeriod.current));
      },
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        items,
        indexOfTodayItem,
        withCreateButton,
        withWarningOnWrongSessionMiloRetrieval,
        pendingActionCreations,
        withPagination,
        shouldShowOnboarding,
      ];
}

DisplayState _displayState(MonSuiviState state) {
  return switch (state) {
    MonSuiviNotInitializedState() => DisplayState.LOADING,
    MonSuiviLoadingState() => DisplayState.LOADING,
    MonSuiviFailureState() => DisplayState.FAILURE,
    MonSuiviSuccessState() => DisplayState.CONTENT,
  };
}

bool _withWarningOnWrongSessionMiloRetrieval(MonSuiviState state) {
  return state is MonSuiviSuccessState && state.monSuivi.errorOnSessionMiloRetrieval;
}

List<MonSuiviItem> _items(Store<AppState> store) {
  final state = store.state.monSuiviState;
  if (state is! MonSuiviSuccessState) return [];
  final entriesByDay = _entriesByDay(state);
  // Day is set to midday to avoid timezone issues while adding Duration(days: 1)
  DateTime jourCourant = state.interval.debut.toMidday();
  final items = <MonSuiviItem>[];
  while (jourCourant.isBefore(state.interval.fin.toEndOfDay())) {
    if (jourCourant.weekday == DateTime.monday) {
      items.add(_semaineSectionItem(jourCourant));
    }

    final entries = entriesByDay.get(jourCourant);
    final day = MonSuiviDay.fromDateTime(jourCourant);
    final isToday = jourCourant.isToday();
    items.add(
      entries != null
          ? FilledDayMonSuiviItem(day, entries, isToday)
          : EmptyDayMonSuiviItem(day, _emptyText(store, jourCourant), isToday),
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

Map<String, List<MonSuiviEntry>> _entriesByDay(MonSuiviState state) {
  if (state is! MonSuiviSuccessState) return {};
  final entriesByDay = <String, List<MonSuiviEntry>>{};
  for (var action in state.monSuivi.actions) {
    entriesByDay.add(action.dateEcheance, UserActionMonSuiviEntry(action.id));
  }
  for (var demarche in state.monSuivi.demarches) {
    if (demarche.endDate != null) {
      entriesByDay.add(demarche.endDate!, DemarcheMonSuiviEntry(demarche.id));
    }
  }
  for (var rdv in state.monSuivi.rendezvous) {
    entriesByDay.add(rdv.date, RendezvousMonSuiviEntry(rdv.id));
  }
  for (var session in state.monSuivi.sessionsMilo) {
    entriesByDay.add(session.dateDeDebut, SessionMiloMonSuiviEntry(session.id));
  }
  return entriesByDay;
}

String _emptyText(Store<AppState> store, DateTime date) {
  if (date.isBefore(clock.now().toStartOfDay())) {
    return store.state.isMiloLoginMode() ? Strings.monSuiviEmptyPastMilo : Strings.monSuiviEmptyPastPoleEmploi;
  } else {
    return Strings.monSuiviEmptyFuture;
  }
}

extension on Map<String, List<MonSuiviEntry>> {
  void add(DateTime date, MonSuiviEntry entry) {
    final dateAsKey = _dateAsKey(date);
    putIfAbsent(dateAsKey, () => []);
    this[dateAsKey]!.add(entry);
  }

  List<MonSuiviEntry>? get(DateTime date) => this[_dateAsKey(date)];

  String _dateAsKey(DateTime date) => DateFormat("DD-yyyy").format(date);
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
  final String text;

  EmptyDayMonSuiviItem(super.day, this.text, [super.isToday = false]);

  @override
  List<Object?> get props => [day, text, isToday];
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

class DemarcheMonSuiviEntry extends MonSuiviEntry {
  final String id;

  DemarcheMonSuiviEntry(this.id);

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

bool _shouldShowOnboarding(Store<AppState> store) {
  return store.state.onboardingState.showMonSuiviOnboarding;
}
