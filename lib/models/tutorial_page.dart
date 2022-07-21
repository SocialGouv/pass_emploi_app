import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class TutorialPage extends Equatable {
  static const String version = '1';

  static List<TutorialPage> milo = [
    TutorialPage._(
      title: Strings.tutoTitreOffreDebutant,
      description: Strings.tutoDescriptionOffreDebutant,
      image: Drawables.icTutoOffreDebutant,
    ),
    TutorialPage._(
      title: Strings.tutoTitreOffrePartage,
      description: Strings.tutoDescriptionOffrePartage,
      image: Drawables.icTutoOffrePartager,
    ),
  ];

  static List<TutorialPage> poleEmploi = [
    TutorialPage._(
      title: Strings.tutoTitreOffreDebutant,
      description: Strings.tutoDescriptionOffreDebutant,
      image: Drawables.icTutoOffreDebutant,
    ),
    TutorialPage._(
      title: Strings.tutoTitreOffrePartage,
      description: Strings.tutoDescriptionOffrePartage,
      image: Drawables.icTutoOffrePartager,
    ),
  ];

  final String title;
  final String description;
  final String image;

  TutorialPage._({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
