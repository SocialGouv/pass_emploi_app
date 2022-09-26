import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum SuggestionType { emploi, alternance, immersion, civique }

SuggestionType? suggestionType(String value) {
  if (value == "OFFRES_EMPLOI") return SuggestionType.emploi;
  if (value == "OFFRES_ALTERNANCE") return SuggestionType.alternance;
  if (value == "OFFRES_IMMERSION") return SuggestionType.immersion;
  if (value == "OFFRES_SERVICES_CIVIQUE") return SuggestionType.civique;
  return null;
}

class SuggestionRecherche extends Equatable {
  final String id;
  final SuggestionType type;
  final String titre;
  final String? metier;
  final String? localisation;
  final DateTime dateCreation;
  final DateTime dateMiseAJour;

  SuggestionRecherche({
    required this.id,
    required this.type,
    required this.titre,
    required this.metier,
    required this.localisation,
    required this.dateCreation,
    required this.dateMiseAJour,
  });

  factory SuggestionRecherche.fromJson(dynamic json) {
    return SuggestionRecherche(
      id: json["id"] as String,
      type: suggestionType(json["type"] as String)!,
      titre: json["titre"] as String,
      metier: json["metier"] as String?,
      localisation: json["localisation"] as String?,
      dateCreation: (json["dateCreation"] as String).toDateTimeUtcOnLocalTimeZone(),
      dateMiseAJour: (json["dateMiseAJour"] as String).toDateTimeUtcOnLocalTimeZone(),
    );
  }

  SuggestionRecherche copyWith({
    String? id,
    SuggestionType? type,
    String? titre,
    String? metier,
    String? localisation,
    DateTime? dateCreation,
    DateTime? dateMiseAJour,
  }) {
    return SuggestionRecherche(
      id: id ?? this.id,
      type: type ?? this.type,
      titre: titre ?? this.titre,
      metier: metier ?? this.metier,
      localisation: localisation ?? this.localisation,
      dateCreation: dateCreation ?? this.dateCreation,
      dateMiseAJour: dateMiseAJour ?? this.dateMiseAJour,
    );
  }

  @override
  List<Object?> get props => [id, type, titre, metier, localisation, dateCreation, dateMiseAJour];
}
