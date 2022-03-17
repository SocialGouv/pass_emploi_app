import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final DateTime minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

extension DateExtensions on DateTime {
  String toDayAndHourContextualized() {
    if (isTomorrow()) return "Demain ${DateFormat('à HH\'h\'mm').format(this)}";
    if (isToday()) return "Aujourd'hui ${DateFormat('à HH\'h\'mm').format(this)}";
    return DateFormat('\'Le\' dd/MM/yyyy à HH\'h\'mm').format(this);
  }

  String toDay() => DateFormat('dd/MM/yyyy').format(this);

  String toDayWithFullMonth() {
    initializeDateFormatting();
    return DateFormat('dd MMMM yyyy', 'fr').format(this);
  }

  String toDayWithFullMonthContextualized() {
    if (isTomorrow()) return "Demain";
    if (isToday()) return "Aujourd'hui";
    return toDayWithFullMonth();
  }

  String toHour() => DateFormat('HH:mm').format(this);

  //String toBackFormat() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").format(this);

  bool isAtSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  bool isToday() => isAtSameDayAs(DateTime.now());

  bool isTomorrow() => isAtSameDayAs(DateTime.now().add(Duration(days: 1)));
}
