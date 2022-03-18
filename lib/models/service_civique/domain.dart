import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class Domaine extends Equatable {
  static Domaine? fromTag(String? tag) => values.firstWhereOrNull((element) => element.tag == tag);
  static Domaine all = values.first;

  static List<Domaine> values = [
    Domaine._("all", "Tous les domaines"),
    Domaine._("environnement", "Environnement"),
    Domaine._("solidarite-insertion", "Solidarité"),
    Domaine._("prevention-protection", "Prévention et protection"),
    Domaine._("sante", "Santé"),
    Domaine._("culture-loisirs", "Culture et loisirs"),
    Domaine._("education", "Éducation"),
    Domaine._("emploi", "Emploi"),
    Domaine._("sport", "Sport"),
    Domaine._("humanitaire", "Humanitaire"),
    Domaine._("animaux", "Animaux"),
    Domaine._("vivre-ensemble", "Vivre ensemble"),
    Domaine._("autre", "Autre"),
  ];

  final String tag;
  final String titre;

  Domaine._(this.tag, this.titre);

  @override
  List<Object?> get props => [tag, titre];

  @override
  String toString() => titre;
}
