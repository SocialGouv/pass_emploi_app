import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';

class Configuration {
  String serverBaseUrl;
  String firebaseEnvironmentPrefix;
  String matomoBaseUrl;
  String matomoSiteId;
  String authClientId;
  String authLoginRedirectUrl;
  String authIssuer;
  List<String> authScopes;
  String authClientSecret;

  Configuration(
      this.serverBaseUrl,
      this.firebaseEnvironmentPrefix,
      this.matomoBaseUrl,
      this.matomoSiteId,
      this.authClientId,
      this.authLoginRedirectUrl,
      this.authIssuer,
      this.authScopes,
      this.authClientSecret);

  static Future<Configuration> build() async {
    await loadEnvironmentVariables();
    final serverBaseUrl = getOrThrow('SERVER_BASE_URL');
    final firebaseEnvironmentPrefix = getOrThrow('FIREBASE_ENVIRONMENT_PREFIX');
    final matomoBaseUrl = getOrThrow('MATOMO_BASE_URL');
    final matomoSiteId = getOrThrow('MATOMO_SITE_ID');
    final authClientId = getOrThrow('AUTH_CLIENT_ID');
    final authLoginRedirectUrl = getOrThrow('AUTH_LOGIN_URL');
    final authIssuer = getOrThrow('AUTH_ISSUER');
    final authScopes = getArrayOrThrow('AUTH_SCOPE');
    final authClientSecret = getOrThrow('AUTH_CLIENT_SECRET');
    return Configuration(
        serverBaseUrl,
        firebaseEnvironmentPrefix,
        matomoBaseUrl,
        matomoSiteId,
        authClientId,
        authLoginRedirectUrl,
        authIssuer,
        authScopes,
        authClientSecret
    );
  }

  static Future<void> loadEnvironmentVariables() async {
    final String stagingEnvFilePath = "env/.env.staging";
    final String prodEnvFilePath = "env/.env.prod";
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    final isStagingFlavor = packageName.contains("staging");
    print("FLAVOR = ${isStagingFlavor ? "staging" : "prod"}");
    return await dotenv.load(fileName: isStagingFlavor ? stagingEnvFilePath : prodEnvFilePath);
  }

  static String getOrThrow(String key) {
    final value =  dotenv.get(key, fallback: "");
    if (value == "") {
      throw (key + " must be set in .env file");
    }
    return value;
  }

  static List<String> getArrayOrThrow(String key) {
    final value =  dotenv.get(key, fallback: "");
    if (value == "") {
      throw (key + " must be set in .env file");
    }
    return value.split(' ');
  }
}
