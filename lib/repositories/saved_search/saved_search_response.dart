class SavedSearchResponse {
  final String id;
  final String titre;
  final String type;
  final String? metier;
  final String? localisation;
  final SavedSearchResponseCriteres criteres;

  SavedSearchResponse({
    required this.id,
    required this.titre,
    required this.type,
    this.metier,
    this.localisation,
    required this.criteres,
  });

  factory SavedSearchResponse.fromJson(dynamic json) {
    return SavedSearchResponse(
      id: json["id"] as String,
      titre: json["titre"] as String,
      type: json["type"] as String,
      metier: json["metier"] as String?,
      localisation: json["localisation"] as String?,
      criteres: SavedSearchResponseCriteres.fromJson(json["criteres"]),
    );
  }
}

class SavedSearchResponseCriteres {
  final String? q;
  final String? departement;
  final bool? alternance;
  final List<String>? experience;
  final List<String>? contrat;
  final List<String>? duree;
  final String? commune;
  final double? rayon;

  SavedSearchResponseCriteres({
    this.q,
    this.departement,
    this.alternance,
    this.experience,
    this.contrat,
    this.duree,
    this.commune,
    this.rayon,
  });

  factory SavedSearchResponseCriteres.fromJson(dynamic json) {
    return SavedSearchResponseCriteres(
      q: json["q"] as String?,
      departement: json["departement"] as String?,
      alternance: json["alternance"] as bool?,
      experience: (json["experience"] as List?)?.map((e) => e as String).toList(),
      contrat: (json["contrat"] as List?)?.map((e) => e as String).toList(),
      duree: (json["duree"] as List?)?.map((e) => e as String).toList(),
      commune: json["commune"] as String?,
      rayon: json["rayon"] as double?,
    );
  }
}
