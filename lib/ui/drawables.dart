import 'package:pass_emploi_app/models/brand.dart';

class Drawables {
  Drawables._();

  static const String _assets = "assets/";
  static const String _svg = ".svg";

  static String appLogo = Brand.isCej() ? "${_assets}logo_app_cej$_svg" : "${_assets}logo_app_brsa$_svg";

  static String badge = "${_assets}ic_badge$_svg";

  static String missionLocaleLogo = "${_assets}logo-mission-locale.webp";
  static String franceTravailLogo = "${_assets}logo-france-travail.webp";
  static String diagorienteLogo = "${_assets}logo_diagoriente.webp";

  static String accueilOnboardingIllustration1 = "${_assets}onboarding/illustration_onboarding_1.webp";
  static String accueilOnboardingIllustration2 = "${_assets}onboarding/illustration_onboarding_2.webp";
  static String illustrationNavigationBottomSheet = "${_assets}onboarding/illustration_navigation_bottom_sheet.webp";

  static String onboardingMonSuiviIllustration = "${_assets}onboarding/illustration_onboarding_mon_suivi.webp";
  static String onboardingChatIllustration = "${_assets}onboarding/illustration_onboarding_chat.webp";
  static String onboardingRechercheIllustration = "${_assets}onboarding/illustration_onboarding_recherche.webp";
  static String onboardingEvenementsIllustration = "${_assets}onboarding/illustration_onboarding_evenements.webp";
  static String onboardingOffreEnregistreeIllustration =
      "${_assets}onboarding/illustration_onboarding_offre_enregistree.webp";

  static String campagneRecrutementBg = "${_assets}campagne_recrutement_bg.webp";

  static String logoInProgress = Brand.isCej() ? cejLogoInProgress : passEmploiLogoInProgress;
  static String cejLogoInProgress = "${_assets}cej_in_progress.webp";
  static String passEmploiLogoInProgress = "${_assets}brsa_in_progress.webp";
}
