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
}
