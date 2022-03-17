import 'package:intl/intl.dart';

/// By default, DateTime are not TimeZone aware. Parsing to UTC then converting to local time zone is required to
/// provide the proper date on device's local.
extension StringToDateExtensions on String {
  DateTime toDateTimeOnLocalTimeZone() => DateFormat("EEE, d MMM yyyy HH:mm:ss z").parseUtc(this).toLocal();

  DateTime toDateTimeUtcOnLocalTimeZone() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parseUtc(this).toLocal();
}

extension StringExtensions on String {
  String firstLetterUpperCased() => length > 1 ? substring(0, 1).toUpperCase() + substring(1) : this;

  String firstLetterLowerCased() => length > 1 ? substring(0, 1).toLowerCase() + substring(1) : this;
}
