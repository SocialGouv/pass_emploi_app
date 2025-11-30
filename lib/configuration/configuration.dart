import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/utils/log.dart';
import 'package:pass_emploi_app/wrappers/package_info_wrapper.dart';

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
  );

  static Future<Configuration> build() async {
    final currentVersion = Version.fromString(await PackageInfoWrapper.getVersion());
    final packageName = await PackageInfoWrapper.getPackageName();
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
    final fuseauHoraire = await FlutterTimezone.getLocalTimezone();
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
    );
  }
}
