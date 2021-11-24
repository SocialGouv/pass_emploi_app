import 'package:intl/intl.dart';

extension StringExtensions on String {
  DateTime toDateTime() {
    return DateFormat("EEE, d MMM yyyy HH:mm:ss z").parse(this);
  }

  DateTime toDateTimeFromPoleEmploi() {
    return DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parse(this);
  }
}
