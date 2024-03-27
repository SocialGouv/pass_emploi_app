import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoWrapper {
  static Future<String> getPackageName() async {
    return (await PackageInfo.fromPlatform()).packageName;
  }

  static Future<String> getVersion() async {
    return (await PackageInfo.fromPlatform()).version;
  }
}
