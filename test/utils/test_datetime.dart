import 'package:intl/intl.dart';

DateTime parseDateTimeWithCurrentTimeZone(String date) {
  return DateFormat("EEE, d MMM yyyy HH:mm:ss z").parseUtc(date).toLocal();
}

DateTime parseDateTimeUtcWithCurrentTimeZone(String date) {
  return DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parseUtc(date).toLocal();
}

DateTime parseDateTimeUnconsideringTimeZone(String date) {
  return DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parse(date);
}
