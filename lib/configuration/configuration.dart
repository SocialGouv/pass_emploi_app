import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/utils/log.dart';

enum Flavor { STAGING, PROD }

class Configuration {
  Flavor flavor;
  String serverBaseUrl;
  String matomoBaseUrl;
  String matomoSiteId;
  String authClientId;
  String authLoginRedirectUrl;
  String authLogoutRedirectUrl;
  String authIssuer;
  List<String> authScopes;
  String authClientSecret;
  String iSRGX1CertificateForOldDevices;

  Configuration(
    this.flavor,
    this.serverBaseUrl,
    this.matomoBaseUrl,
    this.matomoSiteId,
    this.authClientId,
    this.authLoginRedirectUrl,
    this.authLogoutRedirectUrl,
    this.authIssuer,
    this.authScopes,
    this.authClientSecret,
    this.iSRGX1CertificateForOldDevices,
  );

  static Future<Configuration> build() async {
    final packageName = (await PackageInfo.fromPlatform()).packageName;
    final flavor = packageName.contains("staging") ? Flavor.STAGING : Flavor.PROD;
    Log.i("Flavor = $flavor");
    await loadEnvironmentVariables(flavor);
    final serverBaseUrl = getOrThrow('SERVER_BASE_URL');
    final matomoBaseUrl = getOrThrow('MATOMO_BASE_URL');
    final matomoSiteId = getOrThrow('MATOMO_SITE_ID');
    final authClientId = getOrThrow('AUTH_CLIENT_ID');
    final authLoginRedirectUrl = getOrThrow('AUTH_LOGIN_URL');
    final authLogoutRedirectUrl = getOrThrow('AUTH_LOGOUT_URL');
    final authIssuer = getOrThrow('AUTH_ISSUER');
    final authScopes = getArrayOrThrow('AUTH_SCOPE');
    final authClientSecret = getOrThrow('AUTH_CLIENT_SECRET');
    final iSRGX1CertificateForOldDevices = utf8.decode(base64Decode(getOrThrow('ISRGX1_CERT_FOR_OLD_DEVICES')));
    return Configuration(
      flavor,
      serverBaseUrl,
      matomoBaseUrl,
      matomoSiteId,
      authClientId,
      authLoginRedirectUrl,
      authLogoutRedirectUrl,
      authIssuer,
      authScopes,
      authClientSecret,
      iSRGX1CertificateForOldDevices,
    );
  }

  static Future<void> loadEnvironmentVariables(Flavor flavor) async {
    return await dotenv.load(fileName: flavor == Flavor.STAGING ? "env/.env.staging" : "env/.env.prod");
  }

  static String getOrThrow(String key) {
    final value = dotenv.get(key, fallback: "");
    if (value == "") {
      throw (key + " must be set in .env file");
    }
    return value;
  }

  static List<String> getArrayOrThrow(String key) {
    final value = dotenv.get(key, fallback: "");
    if (value == "") {
      throw (key + " must be set in .env file");
    }
    return value.split(' ');
  }
}
