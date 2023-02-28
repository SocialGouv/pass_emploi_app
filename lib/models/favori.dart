import 'package:equatable/equatable.dart';

enum FavoriType { emploi, alternance, immersion, civique }

class Favori extends Equatable {
  final String id;
  final FavoriType type;
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

FavoriType? _typeFromString(String typeString) {
  if (typeString == "OFFRE_EMPLOI") return FavoriType.emploi;
  if (typeString == "OFFRE_ALTERNANCE") return FavoriType.alternance;
  if (typeString == "OFFRE_IMMERSION") return FavoriType.immersion;
  if (typeString == "OFFRE_SERVICE_CIVIQUE") return FavoriType.civique;
  return null;
}
