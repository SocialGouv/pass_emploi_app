import 'package:pass_emploi_app/models/brand.dart';

class Drawables {
  Drawables._();

  static const String _assets = "assets/";
  static const String _svg = ".svg";

  static String appLogo = Brand.isCej() ? "${_assets}logo_app_cej$_svg" : "${_assets}logo_app_brsa$_svg";

  static String badge = "${_assets}ic_badge$_svg";

  static String missionLocaleLogo = "${_assets}logo-mission-locale.webp";
  static String poleEmploiLogo = "${_assets}logo-france-travail.webp";
  static String passEmploiLogo = "${_assets}credentials.png";
}
