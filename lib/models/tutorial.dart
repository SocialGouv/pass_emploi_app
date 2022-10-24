import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class Tutorial extends Equatable {
  static const String version = '4';

  static List<Tutorial> milo = [];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: Strings.tutoTitrePageUne,
      description: Strings.tutoDescriptionPageUne,
      image: Drawables.icTutoNewRecherche1,
    ),
    Tutorial(
      title: Strings.tutoTitrePageDeux,
      description: Strings.tutoDescriptionPageDeux,
      image: Drawables.icTutoNewRecherche2,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
