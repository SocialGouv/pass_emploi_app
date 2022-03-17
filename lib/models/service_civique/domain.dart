import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class Domain extends Equatable {
  static Domain? fromTag(String? tag) => values.firstWhereOrNull((element) => element.tag == tag);

  static List<Domain> values = [
    Domain._("all", "Tous les domaines"),
    Domain._("environnement", "Environnement"),
    Domain._("solidarite-insertion", "Solidarité"),
    Domain._("prevention-protection", "Prévention et protection"),
    Domain._("sante", "Santé"),
    Domain._("culture-loisirs", "Culture et loisirs"),
    Domain._("education", "Éducation"),
    Domain._("emploi", "Emploi"),
    Domain._("sport", "Sport"),
    Domain._("humanitaire", "Humanitaire"),
    Domain._("animaux", "Animaux"),
    Domain._("vivre-ensemble", "Vivre ensemble"),
    Domain._("autre", "Autre"),
  ];

  final String tag;
  final String titre;

  Domain._(this.tag, this.titre);

  @override
  List<Object?> get props => [tag, titre];

  @override
  String toString() => titre;
}
