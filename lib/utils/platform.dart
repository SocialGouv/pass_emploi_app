import 'dart:io' as io;

import 'package:pass_emploi_app/models/brand.dart';

enum Platform {
  IOS,
  ANDROID;

  String getAppStoreUrl(Brand brand) {
    if (brand.isCej && isIos) {
      return 'itms-apps://itunes.apple.com/app/apple-store/id1581603519';
    } else if (brand.isCej && isAndroid) {
      return 'market://details?id=fr.fabrique.social.gouv.passemploi';
    } else if (brand.isPassEmploi && isIos) {
      return 'itms-apps://itunes.apple.com/app/apple-store/id6448051621';
    } else if (brand.isPassEmploi && isAndroid) {
      return 'market://details?id=fr.fabrique.social.gouv.passemploi.rsa';
    }
    return "";
  }
}

extension PlatformExtension on Platform {
  bool get isIos => this == Platform.IOS;
  bool get isAndroid => this == Platform.ANDROID;
}

class PlatformUtils {
  static Platform get getPlatform => io.Platform.isIOS ? Platform.IOS : Platform.ANDROID;
}
