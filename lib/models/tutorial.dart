import 'package:equatable/equatable.dart';

class Tutorial extends Equatable {
  static const String version = '10';

  static const String _tuto = "assets/tuto/";
  static const String _svg = ".svg";

  static String title1 = "Vous avez des CV sur votre espace personnel Pôle emploi ?";
  static String description1 =
      "L’application du CEJ les récupérera automatiquement et vous pourrez les retrouver depuis votre profil";

  static String title2 = "Et surtout… ";
  static String description2 =
      "Téléchargez votre CV sur votre téléphone afin de candidater plus facilement lorsque vous serez redirigé sur le site de l'offre";

  static String svg1 = _tuto + "tuto1" + _svg;
  static String svg2 = _tuto + "tuto2" + _svg;

  static List<Tutorial> milo = [];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: title1,
      description: description1,
      image: svg1,
    ),
    Tutorial(
      title: title2,
      description: description2,
      image: svg2,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
