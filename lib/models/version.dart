import 'package:equatable/equatable.dart';

class Version extends Equatable implements Comparable<Version> {
  final int major;
  final int minor;
  final int patch;

  const Version(this.major, this.minor, this.patch);

  static Version? fromString(String version) {
    try {
      final versionWithoutSuffix = version.replaceAll(RegExp("[^.0-9]"), "");
      final digits = versionWithoutSuffix.split('.').map((versionDigitStr) => int.parse(versionDigitStr)).toList();
      return digits.length == 3 ? Version(digits[0], digits[1], digits[2]) : null;
    } catch (onError) {
      return null;
    }
  }

  @override
  int compareTo(Version other) {
    if (major.compareTo(other.major) != 0) return major.compareTo(other.major);
    if (minor.compareTo(other.minor) != 0) return minor.compareTo(other.minor);
    return patch.compareTo(other.patch);
  }

  bool operator <=(Version other) => compareTo(other) <= 0;

  bool operator >=(Version other) => compareTo(other) >= 0;

  bool operator <(Version other) => compareTo(other) < 0;

  bool operator >(Version other) => compareTo(other) > 0;

  @override
  List<Object?> get props => [major, minor, patch];
}
