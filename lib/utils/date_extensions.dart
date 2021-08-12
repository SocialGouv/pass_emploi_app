import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String toDay() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toHour() => DateFormat('HH:mm').format(this);

  bool isAtSameDayAs(DateTime other) {
    return this.day == other.day && this.month == other.month && this.year == other.year;
  }
}
