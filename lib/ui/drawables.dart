import 'package:pass_emploi_app/models/brand.dart';

class Drawables {
  Drawables._();

  static const String _assets = "assets/";
  static const String _tuto = "assets/tuto/";
  static const String _svg = ".svg";
  static const String _png = ".png";

  static String puzzle = _assets + "puzzle" + _svg;

  static String appLogo = Brand.isCej() ? _assets + "logo_app_cej" + _svg : _assets + "logo_app_brsa" + _svg;

  static String jeuneEntree = _assets + "jeune_home" + _png;
  static String conversation = _assets + "conversation" + _svg;

  static String modeDemoExplicationIllustration = _assets + "connexion" + _svg;
  static String unJeuneUneSolutionIllustration = _assets + "logo_1jeune1solution_light" + _svg;
  static String republiqueFrancaiseLogo = _assets + "logo_republique_francaise" + _svg;
  static String emptyOffresIllustration = _assets + "ic_empty_offres" + _svg;
  static String congratulationsIllustration = _assets + "ic_congratulations" + _svg;
  static String trashAlertIllustration = _assets + "ic_trash_alert" + _svg;
  static String emptyIllustration = _assets + "ic_empty" + _svg;
  static String deleteIllustration = _assets + "ic_delete" + _svg;

  static String badge = _assets + "ic_badge" + _svg;

  static String tutoImgNewImmersionMilo = _tuto + "img_new_immersion_Milo" + _svg;
  static String tutoImgNewImmersionPE = _tuto + "img_new_immersion_PE" + _svg;
  static String tutoImgNewLastSearchMilo = _tuto + "img_new_last_search_Milo" + _svg;
  static String tutoImgNewSearchDiagoMilo = _tuto + "img_new_search_diago_Milo" + _svg;
  static String tutoImgNewSearchDiagoPE = _tuto + "img_new_search_diago_PE" + _svg;
  static String tutoImgProfilDiagoMilo = _tuto + "img_profil_diago_Milo" + _svg;
}
