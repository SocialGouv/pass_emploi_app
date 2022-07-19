enum Platform {
  IOS,
  ANDROID;
  String getAppStoreUrl() {
    switch (this) {
      case Platform.ANDROID:
        return 'market://details?id=fr.fabrique.social.gouv.passemploi';
      case Platform.IOS:
        return 'itms-apps://itunes.apple.com/app/apple-store/id1581603519';
    }
  }

}


