import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/solution_type.dart';

class Favori extends Equatable {
  final String id;
  final SolutionType type;
  final String titre;
  final String? organisation;
  final String? localisation;

  Favori({
    required this.id,
    required this.type,
    required this.titre,
    required this.organisation,
    required this.localisation,
  });

  static Favori? fromJson(dynamic json) {
    final type = _typeFromString(json["type"] as String);
    if (type == null) return null;
    return Favori(
      id: json['idOffre'] as String,
      type: type,
      titre: json['titre'] as String,
      organisation: json['organisation'] as String?,
      localisation: json['localisation'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, type, titre, organisation, localisation];
}

SolutionType? _typeFromString(String typeString) {
  if (typeString == "OFFRE_EMPLOI") return SolutionType.OffreEmploi;
  if (typeString == "OFFRE_ALTERNANCE") return SolutionType.Alternance;
  if (typeString == "OFFRE_IMMERSION") return SolutionType.Immersion;
  if (typeString == "OFFRE_SERVICE_CIVIQUE") return SolutionType.ServiceCivique;
  return null;
}
