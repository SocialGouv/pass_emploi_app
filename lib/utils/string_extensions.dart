import 'package:intl/intl.dart';

/// By default, DateTime are not TimeZone aware. Parsing to UTC then converting to local time zone is required to
/// provide the proper date on device's local.
extension StringExtensions on String {
  DateTime toDateTimeOnLocalTimeZone() => DateFormat("EEE, d MMM yyyy HH:mm:ss z").parseUtc(this).toLocal();

  DateTime toDateTimeUtcOnLocalTimeZone() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parseUtc(this).toLocal();
}
