import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String versionTimestamp = '1718704179';
  static List<TutorialPage> milo = [];
  static List<TutorialPage> pe = [
    TutorialPage(
      title: "Dupliquez aisément vos démarches\u{00A0}!",
      description: "Appuyez longuement sur une démarche pour pouvoir la dupliquer facilement\u{00A0}!",
      image: "assets/tuto/img_mon_suivi_demarche.webp",
    ),
    TutorialPage(
      title: "Dupliquez aisément vos démarches\u{00A0}!",
      description:
          "Retrouvez également la duplication en appuyant sur les trois petits points dans le détail de la démarche.",
      image: "assets/tuto/img_ma_demarche.webp",
    ),
  ];
}
