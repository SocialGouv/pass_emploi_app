import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class Tutorial extends Equatable {
  static const String version = '8';

  static List<Tutorial> milo = [
    Tutorial(
      title: Strings.tutoMiloTitrePageUne,
      description: Strings.tutoMiloDescriptionPageUne,
      image: Drawables.tutoImgNewImmersionMilo,
    ),
    Tutorial(
      title: Strings.tutoMiloTitrePageDeux,
      description: Strings.tutoMiloDescriptionPageDeux,
      image: Drawables.tutoImgProfilDiagoMilo,
    ),
    Tutorial(
      title: Strings.tutoMiloTitrePageTrois,
      description: Strings.tutoMiloDescriptionPageTrois,
      image: Drawables.tutoImgNewSearchDiagoMilo,
    ),
    Tutorial(
      title: Strings.tutoMiloTitrePageQuatre,
      description: Strings.tutoMiloDescriptionPageQuatre,
      image: Drawables.tutoImgNewLastSearchMilo,
    ),
  ];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: Strings.tutoEmploiTitrePageUne,
      description: Strings.tutoEmploiDescriptionPageUne,
      image: Drawables.tutoImgNewImmersionPE,
    ),
    Tutorial(
      title: Strings.tutoEmploiTitrePageDeux,
      description: Strings.tutoEmploiDescriptionPageDeux,
      image: Drawables.tutoImgProfilDiagoMilo,
    ),
    Tutorial(
      title: Strings.tutoEmploiTitrePageTrois,
      description: Strings.tutoEmploiDescriptionPageTrois,
      image: Drawables.tutoImgNewSearchDiagoPE,
    ),
    Tutorial(
      title: Strings.tutoEmploiTitrePageQuatre,
      description: Strings.tutoEmploiDescriptionPageQuatre,
      image: Drawables.tutoImgNewLastSearchMilo,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
