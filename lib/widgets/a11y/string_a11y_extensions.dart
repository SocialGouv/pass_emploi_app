import 'package:pass_emploi_app/ui/strings.dart';

extension A11yStringExtensions on String {
  String toTimeAndDurationForScreenReaders() {
    return replaceAll("h", Strings.a11yHours)
        .replaceAll(":", Strings.a11yHours)
        .replaceAll("min", Strings.a11yMinutes)
        .replaceAll("00", "")
        .replaceAll("(", "(${Strings.a11yDuration}");
  }
}
