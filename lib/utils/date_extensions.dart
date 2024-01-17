import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

final DateTime minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

extension DateExtensions on DateTime {
  String toIso8601WithOffsetDateTime() {
    String twoDigits(int n) => n >= 10 ? "$n" : "0$n";

    final hours = twoDigits(timeZoneOffset.inHours.abs());
    final minutes = twoDigits(timeZoneOffset.inMinutes.remainder(60));
    final sign = timeZoneOffset.isNegative ? "-" : "+";
    final formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(this);

    return "$formattedDate$sign$hours:$minutes";
  }

  String toDayAndHourContextualized() {
    if (isTomorrow()) return "Demain ${DateFormat('à HH\'h\'mm').format(this)}";
    if (isToday()) return "Aujourd'hui ${DateFormat('à HH\'h\'mm').format(this)}";
    return DateFormat('dd/MM/yyyy à HH\'h\'mm').format(this);
  }

  String toDayAndHour() => DateFormat("dd/MM/yyyy à HH'h'mm").format(this);

  String toDay() => DateFormat('dd/MM/yyyy').format(this);

  String toDayOfWeek() => DateFormat('EEEE d', 'fr').format(this);

  String toDayShortened() => DateFormat('EEE', 'fr').format(this);

  String toDayWithFullMonth() => DateFormat('dd MMMM yyyy', 'fr').format(this);

  String toDayWithFullMonthContextualized() {
    if (isTomorrow()) return "Demain";
    if (isToday()) return "Aujourd'hui";
    return toDayWithFullMonth();
  }

  String toDayOfWeekWithFullMonth() => DateFormat('EEEE d MMMM', 'fr').format(this);

  String toDayOfWeekWithFullMonthContextualized() {
    if (isTomorrow()) return "Demain";
    if (isToday()) return "Aujourd'hui";
    return toDayOfWeekWithFullMonth().firstLetterUpperCased();
  }

  String toMonth() => DateFormat('MMMM', 'fr').format(this);

  String toFullMonthAndYear() {
    return DateFormat('MMMM yyyy', 'fr').format(this);
  }

  String toHour() => DateFormat('HH:mm').format(this);

  String toHourWithHSeparator() {
    return switch (minute) {
      0 => DateFormat('HH\'h\'').format(this),
      _ => DateFormat('HH\'h\'mm').format(this),
    };
  }

  bool isAtSameDayAs(DateTime other) => day == other.day && month == other.month && year == other.year;

  bool isAtSameWeekAs(DateTime other) {
    final thisMonday = toMondayOnThisWeek();
    final otherMonday = other.toMondayOnThisWeek();
    return thisMonday.isAtSameDayAs(otherMonday);
  }

  bool isToday() => isAtSameDayAs(clock.now());

  bool isTomorrow() => isAtSameDayAs(clock.now().add(Duration(days: 1)));

  bool isSaturday() => weekday == 6;

  bool isInPreviousDay(DateTime anotherDate) {
    final anotherDayDate = DateUtils.dateOnly(anotherDate);
    final thisDayDate = DateUtils.dateOnly(this);
    return thisDayDate.isBefore(anotherDayDate);
  }

  DateTime toMondayOnThisWeek() => subtract(Duration(days: weekday - 1));

  DateTime toMondayOn2PreviousWeeks() => toMondayOnThisWeek().subtract(Duration(days: 14)).toStartOfDay();

  DateTime toSundayOnThisWeek() => add(Duration(days: 7 - weekday));

  DateTime toSundayOn2NextWeeks() => toSundayOnThisWeek().add(Duration(days: 14)).toEndOfDay();

  DateTime toMondayOnNextWeek() => add(Duration(days: 7 - weekday + 1));

  DateTime addWeeks(int weeks) => add(Duration(days: 7 * weeks));

  DateTime toStartOfDay() => copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  DateTime toEndOfDay() => copyWith(hour: 23, minute: 59, second: 59, millisecond: 999, microsecond: 0);

  int numberOfDaysUntilToday() {
    final from = DateTime(year, month, day);
    final to = DateUtils.dateOnly(clock.now());
    return (to.difference(from).inHours / 24).round();
  }
}
