import 'package:intl/intl.dart';

DateTime parseDateTimeUtcWithCurrentTimeZone(String date) {
  return DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parseUtc(date).toLocal();
}

DateTime parseDateTimeUnconsideringTimeZone(String date) {
  return DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parse(date);
}
