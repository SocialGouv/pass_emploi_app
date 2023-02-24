import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class Tutorial extends Equatable {
  static const String version = '6';

  static List<Tutorial> milo = [
    Tutorial(
      title: Strings.tutoMiloTitrePageUne,
      description: Strings.tutoMiloDescriptionPageUne,
      image: Drawables.tutoProfilHeader,
    ),
    Tutorial(
      title: Strings.tutoMiloTitrePageDeux,
      description: Strings.tutoMiloDescriptionPageDeux,
      image: Drawables.tutoNewEventMilo,
    ),
    Tutorial(
      title: Strings.tutoMiloTitrePageTrois,
      description: Strings.tutoMiloDescriptionPageTrois,
      image: Drawables.tutoNewEventSearchMilo,
    ),
  ];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: Strings.tutoEmploiTitrePageUne,
      description: Strings.tutoEmploiDescriptionPageUne,
      image: Drawables.tutoProfilHeader,
    ),
    Tutorial(
      title: Strings.tutoEmploiTitrePageDeux,
      description: Strings.tutoEmploiDescriptionPageDeux,
      image: Drawables.tutoNewEventPe,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
