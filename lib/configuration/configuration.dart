import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/utils/log.dart';

enum Flavor { STAGING, PROD }

class Configuration extends Equatable {
  final Version? version;
  final Flavor flavor;
  final Brand brand;
  final String serverBaseUrl;
  final String matomoBaseUrl;
  final String matomoSiteId;
  final String matomoDimensionProduitId;
  final String matomoDimensionAvecConnexionId;
  final String authClientId;
  final String authLoginRedirectUrl;
  final String authLogoutRedirectUrl;
  final String authIssuer;
  final List<String> authScopes;
  final String authClientSecret;
  final String iSRGX1CertificateForOldDevices;
  final String actualisationPoleEmploiUrl;
  final String fuseauHoraire;
  final String cvmEx160Url;
  final String cvmAttachmentUrl;

  Configuration(
    this.version,
    this.flavor,
    this.brand,
    this.serverBaseUrl,
    this.matomoBaseUrl,
    this.matomoSiteId,
    this.matomoDimensionProduitId,
    this.matomoDimensionAvecConnexionId,
    this.authClientId,
    this.authLoginRedirectUrl,
    this.authLogoutRedirectUrl,
    this.authIssuer,
    this.authScopes,
    this.authClientSecret,
    this.iSRGX1CertificateForOldDevices,
    this.actualisationPoleEmploiUrl,
    this.fuseauHoraire,
    this.cvmEx160Url,
    this.cvmAttachmentUrl,
  );

  static Future<Configuration> build() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.fromString(packageInfo.version);
    final packageName = packageInfo.packageName;
    final flavor = packageName.contains("staging") ? Flavor.STAGING : Flavor.PROD;
    Log.i("Flavor = $flavor");
    await loadEnvironmentVariables(flavor);
    final brand = Brand.brand;
    final serverBaseUrl = getOrThrow('SERVER_BASE_URL');
    final matomoBaseUrl = getOrThrow('MATOMO_BASE_URL');
    final matomoSiteId = getOrThrow('MATOMO_SITE_ID');
    final matomoDimensionProduitId = getOrThrow('MATOMO_DIMENSION_PRODUIT_ID');
    final matomoDimensionAvecConnexionId = getOrThrow('MATOMO_DIMENSION_AVEC_CONNEXION_ID');
    final authClientId = getOrThrow('AUTH_CLIENT_ID');
    final authLoginRedirectUrl = getOrThrow('AUTH_LOGIN_URL');
    final authLogoutRedirectUrl = getOrThrow('AUTH_LOGOUT_URL');
    final authIssuer = getOrThrow('AUTH_ISSUER');
    final authScopes = getArrayOrThrow('AUTH_SCOPE');
    final authClientSecret = getOrThrow('AUTH_CLIENT_SECRET');
    final iSRGX1CertificateForOldDevices = utf8.decode(base64Decode(getOrThrow('ISRGX1_CERT_FOR_OLD_DEVICES')));
    final actualisationPoleEmploiUrl = getOrThrow('ACTUALISATION_PE_URL');
    final fuseauHoraire = await FlutterNativeTimezone.getLocalTimezone();
    final cvmEx160Url = getCvmEx160Url(getOrThrow('CVM_PATH'));
    final cvmAttachmentUrl = getCvmAttachmentUrl(getOrThrow('CVM_PATH'));
    return Configuration(
      currentVersion,
      flavor,
      brand,
      serverBaseUrl,
      matomoBaseUrl,
      matomoSiteId,
      matomoDimensionProduitId,
      matomoDimensionAvecConnexionId,
      authClientId,
      authLoginRedirectUrl,
      authLogoutRedirectUrl,
      authIssuer,
      authScopes,
      authClientSecret,
      iSRGX1CertificateForOldDevices,
      actualisationPoleEmploiUrl,
      fuseauHoraire,
      cvmEx160Url,
      cvmAttachmentUrl,
    );
  }

  static Future<void> loadEnvironmentVariables(Flavor flavor) async {
    return await dotenv.load(fileName: flavor == Flavor.STAGING ? "env/.env.staging" : "env/.env.prod");
  }

  static String getOrThrow(String key) {
    final value = dotenv.get(key, fallback: "");
    if (value == "") {
      throw ("$key must be set in .env file");
    }
    return value;
  }

  static List<String> getArrayOrThrow(String key) {
    final value = dotenv.get(key, fallback: "");
    if (value == "") {
      throw ("$key must be set in .env file");
    }
    return value.split(' ');
  }

  static String getCvmEx160Url(String cvmPath) {
    return 'https://$cvmPath/identification/v1/authentification/CEJ';
  }

  static String getCvmAttachmentUrl(String cvmPath) {
    return 'https://$cvmPath/_matrix/media/v3/download/$cvmPath/';
  }

  @override
  List<Object?> get props => [
        version,
        flavor,
        brand,
        serverBaseUrl,
        matomoBaseUrl,
        matomoSiteId,
        matomoDimensionProduitId,
        authClientId,
        authLoginRedirectUrl,
        authLogoutRedirectUrl,
        authIssuer,
        authScopes,
        authClientSecret,
        iSRGX1CertificateForOldDevices,
        actualisationPoleEmploiUrl,
        fuseauHoraire,
        cvmEx160Url,
        cvmAttachmentUrl,
      ];

  Configuration copyWith({
    Version? version,
    Flavor? flavor,
    Brand? brand,
    String? serverBaseUrl,
    String? matomoBaseUrl,
    String? matomoSiteId,
    String? matomoDimensionProduitId,
    String? matomoDimensionAvecConnexionId,
    String? authClientId,
    String? authLoginRedirectUrl,
    String? authLogoutRedirectUrl,
    String? authIssuer,
    List<String>? authScopes,
    String? authClientSecret,
    String? iSRGX1CertificateForOldDevices,
    String? actualisationPoleEmploiUrl,
    String? fuseauHoraire,
    String? cvmEx160Url,
    String? cvmAttachmentUrl,
  }) {
    return Configuration(
      version ?? this.version,
      flavor ?? this.flavor,
      brand ?? this.brand,
      serverBaseUrl ?? this.serverBaseUrl,
      matomoBaseUrl ?? this.matomoBaseUrl,
      matomoSiteId ?? this.matomoSiteId,
      matomoDimensionProduitId ?? this.matomoDimensionProduitId,
      matomoDimensionAvecConnexionId ?? this.matomoDimensionAvecConnexionId,
      authClientId ?? this.authClientId,
      authLoginRedirectUrl ?? this.authLoginRedirectUrl,
      authLogoutRedirectUrl ?? this.authLogoutRedirectUrl,
      authIssuer ?? this.authIssuer,
      authScopes ?? this.authScopes,
      authClientSecret ?? this.authClientSecret,
      iSRGX1CertificateForOldDevices ?? this.iSRGX1CertificateForOldDevices,
      actualisationPoleEmploiUrl ?? this.actualisationPoleEmploiUrl,
      fuseauHoraire ?? this.fuseauHoraire,
      cvmEx160Url ?? this.cvmEx160Url,
      cvmAttachmentUrl ?? this.cvmAttachmentUrl,
    );
  }
}
