import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String version = '1690812072';
  static List<TutorialPage> milo = [];
  static List<TutorialPage> pe = [
    TutorialPage(
      title: "Renseignez plus facilement vos démarches grâce à la recherche par thématique",
      description: "Dans l'onglet \"Démarches\", choisissez une démarche pré-définie parmi différentes thématiques",
      image: "assets/tuto/c15a8676081d7a5eed9fcd2e0e40cf85bfb87010b7ee5557f7944d629a35efed.svg",
    ),
    TutorialPage(
      title: "Renseignez plus facilement vos démarches grâce aux top démarches",
      description: "Dans l'onglet \"Démarches\", choisissez une démarche pré-définie parmi les plus utilisées",
      image: "assets/tuto/f0c9c2f4c6b3bf92989b89acd3694ab4a496b231bef3ba2e47fac72ac079f18b.svg",
    ),
  ];
}
