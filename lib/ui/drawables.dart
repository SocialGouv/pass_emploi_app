import 'package:pass_emploi_app/models/brand.dart';

class Drawables {
  Drawables._();

  static const String _assets = "assets/";
  static const String _svg = ".svg";
  static const String _png = ".png";

  static String appLogo = Brand.isCej() ? "${_assets}logo_app_cej$_svg" : "${_assets}logo_app_brsa$_svg";

  static String jeuneEntree = "${_assets}jeune_home$_png";

  static String unJeuneUneSolutionIllustration = "${_assets}logo_1jeune1solution_light$_svg";
  static String republiqueFrancaiseLogo = "${_assets}logo_republique_francaise$_svg";

  static String badge = "${_assets}ic_badge$_svg";
}
