import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String versionTimestamp = '1718704177';
  static List<TutorialPage> milo = [
    TutorialPage(
      title: "Modifiez, dupliquez et supprimez aisément vos actions\u{00A0}!",
      description:
          "Appuyez longuement sur une action pour voir les options d'édition. Vous pouvez ainsi modifier, dupliquer ou supprimer facilement vos actions\u{00A0}!",
      image: "assets/tuto/img_mon_suivi.webp",
    ),
    TutorialPage(
      title: "Modifiez, dupliquez et supprimez aisément vos actions\u{00A0}!",
      description:
          "Retrouvez également ces fonctions en appuyant sur les trois petits points dans le détail de l'action.",
      image: "assets/tuto/img_mon_action.webp",
    ),
  ];
  static List<TutorialPage> pe = [];
}