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
    final int thisVersion = major * 1000000 + minor * 1000 + patch;
    final int otherVersion = other.major * 1000000 + other.minor * 1000 + other.patch;
    return thisVersion.compareTo(otherVersion);
  }

  bool operator <=(Version other) => compareTo(other) <= 0;

  bool operator >=(Version other) => compareTo(other) >= 0;

  bool operator <(Version other) => compareTo(other) < 0;

  bool operator >(Version other) => compareTo(other) > 0;

  @override
  List<Object?> get props => [major, minor, patch];
}
