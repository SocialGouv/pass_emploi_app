import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configuration {
  String serverBaseUrl;
  String firebaseEnvironmentPrefix;
  String matomoBaseUrl;
  String matomoSiteId;

  Configuration(
      this.serverBaseUrl,
      this.firebaseEnvironmentPrefix,
      this.matomoBaseUrl,
      this.matomoSiteId);

  static build() async {
    await loadEnvironmentVariables();
    var serverBaseUrl = getOrThrow('SERVER_BASE_URL');
    var firebaseEnvironmentPrefix = getOrThrow('FIREBASE_ENVIRONMENT_PREFIX');
    var matomoBaseUrl = getOrThrow('MATOMO_BASE_URL');
    var matomoSiteId = getOrThrow('MATOMO_SITE_ID');
    return Configuration(serverBaseUrl, firebaseEnvironmentPrefix, matomoBaseUrl, matomoSiteId);
  }

  static Future<void> loadEnvironmentVariables() async {
    try {
      return await dotenv.load(fileName: 'env/.env');
    } catch (e) {
    }
  }

  static String getOrThrow(String key) {
    var value =  dotenv.get(key, fallback: String.fromEnvironment(key));
    if (value == "") {
      throw (key + " must be set in .env file or in environment variable");
    }
    return value;
  }
}
