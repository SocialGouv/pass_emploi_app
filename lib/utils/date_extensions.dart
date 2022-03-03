import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final DateTime minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

extension DateExtensions on DateTime {
  String toDayAndHour() => DateFormat('dd/MM/yyyy à HH:mm').format(this);

  String toDay() => DateFormat('dd/MM/yyyy').format(this);

  String toDayWithFullMonth() {
    initializeDateFormatting();
    return DateFormat('dd MMMM yyyy', 'fr').format(this);
  }

  String toHour() => DateFormat('HH:mm').format(this);

  bool isAtSameDayAs(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }
}
