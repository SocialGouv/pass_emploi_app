import 'package:pass_emploi_app/models/version.dart';

class AppVersionChecker {
  bool shouldForceUpdate({String? currentVersion, String? minimumVersion}) {
    final Version? current = currentVersion != null ? Version.fromString(currentVersion) : null;
    final Version? minimum = minimumVersion != null ? Version.fromString(minimumVersion) : null;
    if (current == null || minimum == null) return false;
    return current < minimum;
  }
}
