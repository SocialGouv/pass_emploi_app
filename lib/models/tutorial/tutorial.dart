import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String versionTimestamp = '1696511133';
  static List<TutorialPage> milo = [
    TutorialPage(
      title: "Récupérez vos dernières informations à jour à la demande !",
      description:
          "En swippant vers le bas sur les écrans au format liste, vous aurez accès à vos dernières informations à jour.",
      image: "assets/tuto/img_pull_Milo.svg",
    ),
  ];
  static List<TutorialPage> pe = [
    TutorialPage(
      title: "Récupérez vos dernières informations à jour à la demande !",
      description:
          "En swippant vers le bas sur les écrans au format liste, vous aurez accès à vos dernières informations à jour.",
      image: "assets/tuto/img_pull_PE.svg",
    ),
  ];
}
