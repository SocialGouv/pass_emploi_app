import 'package:pass_emploi_app/wrappers/package_info_wrapper.dart';

class AppVersionRepository {
  String? _appVersion;

  Future<String> getAppVersion() async {
    final appVersionCopy = _appVersion;
    if (appVersionCopy != null) {
      return appVersionCopy;
    } else {
      final appVersion = await PackageInfoWrapper.getVersion();
      _appVersion = appVersion;
      return appVersion;
    }
  }
}
