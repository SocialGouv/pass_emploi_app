import 'dart:io';

import 'package:package_info/package_info.dart';

class HeadersBuilder {
  String? _appVersion;

  Future<Map<String, String>> headers({String? userId, String? contentType}) async {
    return {
      if (userId != null) 'X-CorrelationId': userId + "-" + DateTime.now().millisecondsSinceEpoch.toString(),
      if (userId != null) 'X-InstallationId': userId,
      if (contentType != null) 'Content-Type': contentType,
      'X-AppVersion': await _getAppVersion(),
      'X-Platform': Platform.operatingSystem,
    };
  }

  Future<String> _getAppVersion() async {
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
