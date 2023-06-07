import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

enum SuggestionSource {
  poleEmploi,
  conseiller,
  diagoriente;

  static SuggestionSource? from(String value) {
    if (value == "POLE_EMPLOI") return SuggestionSource.poleEmploi;
    if (value == "CONSEILLER") return SuggestionSource.conseiller;
    if (value == "DIAGORIENTE") return SuggestionSource.diagoriente;
    return null;
  }
}

class SuggestionRecherche extends Equatable {
  final String id;
  final String titre;
  final OffreType type;
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
      type: OffreType.from(json["type"] as String) ?? OffreType.emploi,
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
    OffreType? type,
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
