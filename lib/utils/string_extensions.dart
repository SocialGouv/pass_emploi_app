import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

/// By default, DateTime are not TimeZone aware. Parsing to UTC then converting to local time zone is required to
/// provide the proper date on device's local.
extension StringToDateExtensions on String {
  DateTime toDateTimeOnLocalTimeZone() => DateFormat("EEE, d MMM yyyy HH:mm:ss z").parseUtc(this).toLocal();

  DateTime toDateTimeUtcOnLocalTimeZone() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parseUtc(this).toLocal();

  DateTime toDateTimeUtcWithoutTimeZone() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSS").parseUtc(this).toLocal();

  DateTime toDateTimeUnconsideringTimeZone() => DateFormat("yyyy-MM-DDTHH:mm:ss.SSSz").parse(this);

  DateTime? timeToDateTime() {
    final times = split(":");
    if (times.length < 2) return null;
    return DateTime(1970, 1, 1, int.parse(times[0]), int.parse(times[1]));
  }
}

extension StringExtensions on String {
  String firstLetterUpperCased() => length > 1 ? substring(0, 1).toUpperCase() + substring(1) : this;

  String firstLetterLowerCased() => length > 1 ? substring(0, 1).toLowerCase() + substring(1) : this;

  String removeAccents() {
    const withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var str = this;
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }
}

extension StringList on List<String> {
  List<String> sortedAlphabetically() => sorted(compareStringSortedAlphabetically);
}

int compareStringSortedAlphabetically(String a, String b) {
  return a.toUpperCase().removeAccents().compareTo(b.toUpperCase().removeAccents());
}
