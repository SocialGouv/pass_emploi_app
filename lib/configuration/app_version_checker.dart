class AppVersionChecker {
  bool shouldForceUpdate({String? currentVersion, String? minimumVersion}) {
    final Version? current = _extractVersion(currentVersion);
    final Version? minimum = _extractVersion(minimumVersion);

    if (current == null || minimum == null) {
      return false;
    }

    if (current.major > minimum.major) {
      return false;
    } else {
      if (current.major == minimum.major) {
        if (current.minor > minimum.minor) {
          return false;
        } else {
          if (current.minor == minimum.minor) {
            return current.patch < minimum.patch;
          } else {
            return true;
          }
        }
      } else {
        return true;
      }
    }
  }

  Version? _extractVersion(String? version) {
    if (version == null) return null;
    try {
      final versionWithoutSuffix = version.replaceAll(RegExp("[^.0-9]"), "");
      final digits = versionWithoutSuffix.split('.').map((versionDigitStr) => int.parse(versionDigitStr)).toList();
      return digits.length == 3 ? Version(digits[0], digits[1], digits[2]) : null;
    } catch (onError) {
      return null;
    }
  }
}

class Version {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch);
}
