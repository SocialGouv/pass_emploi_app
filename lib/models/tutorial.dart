import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class Tutorial extends Equatable {
  static const String version = '2';

  static List<Tutorial> milo = [
    Tutorial._(
      title: Strings.tutoTitleActionComments,
      description: Strings.tutoDescriptionActionComments,
      image: Drawables.icTutoActionComment,
    ),
    Tutorial._(
      title: Strings.tutoTitreMandatoryDate,
      description: Strings.tutoDescriptionMandatoryDate,
      image: Drawables.icTutoMandatoryDate,
    ),
    Tutorial._(
      title: Strings.tutoTitreAgenda,
      description: Strings.tutoDescriptionAgenda,
      image: Drawables.icTutoAgenda,
    ),
  ];

  static List<Tutorial> poleEmploi = [
    Tutorial._(
      title: Strings.tutoTitreCreationDemarches,
      description: Strings.tutoDescriptionCreationDemarches,
      image: Drawables.icTutoCreationDemarche,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial._({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
