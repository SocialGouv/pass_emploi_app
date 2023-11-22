import 'package:package_info_plus/package_info_plus.dart';

class AppVersionRepository {
  String? _appVersion;

  Future<String> getAppVersion() async {
    final appVersionCopy = _appVersion;
    if (appVersionCopy != null) {
      return appVersionCopy;
    } else {
      final appVersion = (await PackageInfo.fromPlatform()).version;
      _appVersion = appVersion;
      return appVersion;
    }
  }
}
