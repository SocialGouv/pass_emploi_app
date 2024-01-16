import 'package:equatable/equatable.dart';

class MonSuiviViewModel {}

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
