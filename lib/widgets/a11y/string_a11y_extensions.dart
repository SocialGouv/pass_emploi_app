import 'package:pass_emploi_app/ui/strings.dart';

extension A11yStringExtensions on String {
  String toTimeAndDurationForScreenReaders() {
    return replaceAll("h", Strings.a11yHours)
        .replaceAll(":", Strings.a11yHours)
        .replaceAll("min", Strings.a11yMinutes)
        .replaceAll("00", "")
        .replaceAll("(", "(${Strings.a11yDuration}");
  }

  String toFullDayForScreenReaders() {
    return replaceAll("lun.", Strings.a11yMonday)
        .replaceAll("mar.", Strings.a11yTuesday)
        .replaceAll("mer.", Strings.a11yWednesday)
        .replaceAll("jeu.", Strings.a11yThursday)
        .replaceAll("ven.", Strings.a11yFriday)
        .replaceAll("sam.", Strings.a11ySaturday)
        .replaceAll("dim.", Strings.a11ySunday);
  }

  String toDateForScreenReaders() {
    return replaceAll("/01", Strings.a11yJanuary)
        .replaceAll("/02", Strings.a11yFebruary)
        .replaceAll("/03", Strings.a11yMarch)
        .replaceAll("/04", Strings.a11yApril)
        .replaceAll("/05", Strings.a11yMay)
        .replaceAll("/06", Strings.a11yJune)
        .replaceAll("/07", Strings.a11yJuly)
        .replaceAll("/08", Strings.a11yAugust)
        .replaceAll("/09", Strings.a11ySeptember)
        .replaceAll("/10", Strings.a11yOctober)
        .replaceAll("/11", Strings.a11yNovember)
        .replaceAll("/12", Strings.a11yDecember)
        .replaceAll("/", "");
  }
}
