import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String version = '1687509259';
  static List<TutorialPage> milo = [
    TutorialPage(
      title: "Retrouvez les événements liés à l’emploi organisés autour de chez vous !",
      description:
          "Dans l'onglet \"Mes événements\", retrouvez désormais les différents types d'événements organisés au sein de votre Mission Locale ou en dehors de votre Mission Locale",
      image: "assets/tuto/img_evenements_MiLo.svg",
    ),
  ];
  static List<TutorialPage> pe = [
    TutorialPage(
      title: "Retrouvez les événements liés à l’emploi organisés autour de chez vous !",
      description:
          "Dans l'onglet \"Mes événements\", recherchez différents types d'événements organisés au sein de votre agence ou par des partenaires externes",
      image: "assets/tuto/img_evenement_PE.svg",
    ),
  ];
}
