import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info/package_info.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

enum Flavor { STAGING, PROD }

class Configuration {
  final Version? version;
  final Flavor flavor;
  final String serverBaseUrl;
  final String matomoBaseUrl;
  final String matomoSiteId;
  final String authClientId;
  final String authLoginRedirectUrl;
  final String authLogoutRedirectUrl;
  final String authIssuer;
  final List<String> authScopes;
  final String authClientSecret;
  final String iSRGX1CertificateForOldDevices;
  final String actualisationPoleEmploiUrl;
  final String fuseauHoraire;

  Configuration(
      this.version,
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
      this.actualisationPoleEmploiUrl,
      this.fuseauHoraire);

  static Future<Configuration> build() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.fromString(packageInfo.version);
    final packageName = packageInfo.packageName;
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
    final actualisationPoleEmploiUrl = getOrThrow('ACTUALISATION_PE_URL');
    final fuseauHoraire = await FlutterNativeTimezone.getLocalTimezone();
    return Configuration(
        currentVersion,
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
        actualisationPoleEmploiUrl,
        fuseauHoraire);
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
