import 'package:pass_emploi_app/models/brand.dart';

enum Platform {
  IOS,
  ANDROID;

  String getAppStoreUrl(Brand brand) {
    if (brand.isCej && isIos) {
      return 'itms-apps://itunes.apple.com/app/apple-store/id1581603519';
    } else if (brand.isCej && isAndroid) {
      return 'market://details?id=fr.fabrique.social.gouv.passemploi';
    } else if (brand.isBrsa && isIos) {
      return 'TODO: BRSA Apple store url';
    } else if (brand.isBrsa && isAndroid) {
      return 'TODO: BRSA Play store url';
    }
    return "";
  }
}

extension PlatformExtension on Platform {
  bool get isIos => this == Platform.IOS;
  bool get isAndroid => this == Platform.ANDROID;
}
