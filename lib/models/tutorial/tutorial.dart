import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String version = '1687507063';
  static List<TutorialPage> milo = [
    TutorialPage(
      title:
          "Retrouvez les événements liés à l’emploi organisés autour de chez vous !",
      description:
          "Dans l'onglet \"Mes événements\", retrouvez désormais les différents types d'événements organisés au sein de votre Mission Locale ou en dehors de votre Mission Locale",
      image:
          "assets/tuto/c90e1c722f3e05c0138d54065932f6b846fb7a0bcac34493ca4451fbf904de3e.svg",
    ),
  ];
  static List<TutorialPage> pe = [
    TutorialPage(
      title:
          "Retrouvez les événements liés à l’emploi organisés autour de chez vous !",
      description:
          "Dans l'onglet \"Mes événements\", recherchez différents types d'événements organisés au sein de votre agence ou par des partenaires externes",
      image:
          "assets/tuto/ec0b737d3d9d76b395cdd22fe6813af08341ed35c9783e56b2ec8a74c247070c.svg",
    ),
  ];
}
