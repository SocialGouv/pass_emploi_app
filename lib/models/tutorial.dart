import 'package:equatable/equatable.dart';

class Tutorial extends Equatable {
  static const String version = '9';

  static const String _tuto = "assets/tuto/";
  static const String _svg = ".svg";

  static String title1 = "Découvrez votre nouvelle page d'accueil !";
  static String title2 = "Retrouvez le récapitulatif de votre semaine !";
  static String title3 = "Consultez votre prochain rendez-vous";
  static String title4 = "Retrouvez vos alertes plus facilement...";
  static String title5 = "ainsi que vos favoris !";
  static String description1 = "Swipez pour en savoir plus !";
  static String descriptionPe2 = "Avec la synthèse de vos rendez-vous et vos démarches à réaliser sur la semaine";
  static String descriptionMilo2 = "Avec la synthèse de vos rendez-vous et actions à réaliser sur la semaine";
  static String description3 = "";
  static String description4 =
      "Vous avez sauvegardé des recherches d'offres ? Visualisez les dans la nouvelle section alerte";
  static String description5 = "Retrouvez également vos offres mises en favoris";

  static String svgPe1 = _tuto + "tuto_pe1" + _svg;
  static String svgMilo1 = _tuto + "tuto_milo1" + _svg;
  static String svgPe2 = _tuto + "tuto_pe2" + _svg;
  static String svgMilo2 = _tuto + "tuto_milo2" + _svg;
  static String svg3 = _tuto + "tuto3" + _svg;
  static String svg4 = _tuto + "tuto4" + _svg;
  static String svg5 = _tuto + "tuto5" + _svg;

  static List<Tutorial> milo = [
    Tutorial(
      title: title1,
      description: description1,
      image: svgMilo1,
    ),
    Tutorial(
      title: title2,
      description: descriptionMilo2,
      image: svgMilo2,
    ),
    Tutorial(
      title: title3,
      description: description3,
      image: svg3,
    ),
    Tutorial(
      title: title4,
      description: description4,
      image: svg4,
    ),
    Tutorial(
      title: title5,
      description: description5,
      image: svg5,
    ),
  ];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: title1,
      description: description1,
      image: svgPe1,
    ),
    Tutorial(
      title: title2,
      description: descriptionPe2,
      image: svgPe2,
    ),
    Tutorial(
      title: title3,
      description: description3,
      image: svg3,
    ),
    Tutorial(
      title: title4,
      description: description4,
      image: svg4,
    ),
    Tutorial(
      title: title5,
      description: description5,
      image: svg5,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
