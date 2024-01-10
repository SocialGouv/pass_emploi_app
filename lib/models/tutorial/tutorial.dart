import 'package:pass_emploi_app/models/tutorial/tutorial_page.dart';

class Tutorial {
  static const String versionTimestamp = '1696511134';
  static List<TutorialPage> milo = [
    TutorialPage(
      title: "Le parcours de création des actions fait peau neuve !",
      description: "Choississez dans un premier temps la catégorie de votre action",
      image: "assets/tuto/img_creation_categorie.svg",
    ),
    TutorialPage(
      title: "Le parcours de création des actions fait peau neuve !",
      description: "Puis le nom de votre action grâce aux suggestions d’activité qui vous sont proposées",
      image: "assets/tuto/img_creation_titre.svg",
    ),
    TutorialPage(
      title: "Le parcours de création des actions fait peau neuve !",
      description: "Enfin, le statut et la date de réalisation de votre action",
      image: "assets/tuto/img_creation_date.svg",
    ),
    TutorialPage(
      title: "Le parcours de création des actions fait peau neuve !",
      description: "Et hop, c’est terminé ! Maintenant, à vous de jouer !",
      image: "assets/tuto/img_creation_fin.svg",
    ),
  ];
  static List<TutorialPage> pe = [];
}
