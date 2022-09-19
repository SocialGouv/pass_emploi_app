import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class Tutorial extends Equatable {
  static const String version = '3';

  static List<Tutorial> milo = [];

  static List<Tutorial> poleEmploi = [
    Tutorial(
      title: Strings.tutoTitreAgenda,
      description: Strings.tutoDescriptionAgenda,
      image: Drawables.icTutoNewSuiviDemarches,
    ),
  ];

  final String title;
  final String description;
  final String image;

  Tutorial({required this.title, required this.description, required this.image});

  @override
  List<Object?> get props => [title, description, image];
}
