import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum SuggestionType {
  emploi,
  alternance,
  immersion,
  civique;

  static SuggestionType? from(String value) {
    if (value == "OFFRES_EMPLOI") return SuggestionType.emploi;
    if (value == "OFFRES_ALTERNANCE") return SuggestionType.alternance;
    if (value == "OFFRES_IMMERSION") return SuggestionType.immersion;
    if (value == "OFFRES_SERVICES_CIVIQUE") return SuggestionType.civique;
    return null;
  }
}

enum SuggestionSource {
  poleEmploi,
  conseiller;

  static SuggestionSource? from(String value) {
    if (value == "POLE_EMPLOI") return SuggestionSource.poleEmploi;
    if (value == "CONSEILLER") return SuggestionSource.conseiller;
    return null;
  }
}

class SuggestionRecherche extends Equatable {
  final String id;
  final String titre;
  final SuggestionType type;
  final SuggestionSource? source;
  final String? metier;
  final String? localisation;
  final DateTime dateCreation;
  final DateTime dateRafraichissement;

  SuggestionRecherche({
    required this.id,
    required this.titre,
    required this.type,
    required this.source,
    required this.metier,
    required this.localisation,
    required this.dateCreation,
    required this.dateRafraichissement,
  });

  factory SuggestionRecherche.fromJson(dynamic json) {
    return SuggestionRecherche(
      id: json["id"] as String,
      titre: json["titre"] as String,
      type: SuggestionType.from(json["type"] as String) ?? SuggestionType.emploi,
      source: SuggestionSource.from(json["source"] as String),
      metier: json["metier"] as String?,
      localisation: json["localisation"] as String?,
      dateCreation: (json["dateCreation"] as String).toDateTimeUtcOnLocalTimeZone(),
      dateRafraichissement: (json["dateRafraichissement"] as String).toDateTimeUtcOnLocalTimeZone(),
    );
  }

  SuggestionRecherche copyWith({
    String? id,
    String? titre,
    SuggestionType? type,
    SuggestionSource? source,
    String? metier,
    String? localisation,
    DateTime? dateCreation,
    DateTime? dateRafraichissement,
  }) {
    return SuggestionRecherche(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      type: type ?? this.type,
      source: source ?? this.source,
      metier: metier ?? this.metier,
      localisation: localisation ?? this.localisation,
      dateCreation: dateCreation ?? this.dateCreation,
      dateRafraichissement: dateRafraichissement ?? this.dateRafraichissement,
    );
  }

  @override
  List<Object?> get props => [id, titre, type, source, metier, localisation, dateCreation, dateRafraichissement];
}
