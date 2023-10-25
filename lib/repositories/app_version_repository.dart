import 'package:package_info/package_info.dart';

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
