import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class OffreEmploi extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final bool isAlternance;
  final String? location;
  final String? duration;
  final Origin? origin;

  OffreEmploi({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.isAlternance,
    required this.location,
    required this.duration,
    required this.origin,
  });

  factory OffreEmploi.fromJson(dynamic json) {
    return OffreEmploi(
      id: json["id"] as String,
      title: json["titre"] as String,
      companyName: json["nomEntreprise"] as String?,
      contractType: json["typeContrat"] as String,
      isAlternance: json['alternance'] as bool,
      location: _getLocation(json),
      duration: json["duree"] as String?,
      origin: Origin.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titre": title,
      "nomEntreprise": companyName,
      "typeContrat": contractType,
      "alternance": isAlternance,
      "localisation": {"nom": location},
      "duree": duration,
      if (origin != null) "origine": origin!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        contractType,
        isAlternance,
        location,
        duration,
        origin,
      ];
}

sealed class Origin extends Equatable {
  static Origin? fromJson(dynamic json) {
    final origin = json["origine"];
    if (origin == null) return null;
    if (origin["nom"] == Strings.franceTravail) return FranceTravailOrigin();
    return PartenaireOrigin(
      name: origin["nom"] as String,
      logoUrl: origin["logo"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return switch (this) {
      FranceTravailOrigin() => {"nom": Strings.franceTravail},
      final PartenaireOrigin origin => {"nom": origin.name, "logo": origin.logoUrl},
    };
  }
}

class PartenaireOrigin extends Origin {
  final String name;
  final String logoUrl;

  PartenaireOrigin({required this.name, required this.logoUrl});

  @override
  List<Object?> get props => [name, logoUrl];
}

class FranceTravailOrigin extends Origin {
  @override
  List<Object?> get props => [];
}

String? _getLocation(dynamic json) {
  final nom = (json["localisation"]["nom"] as String?);
  if (nom == null || nom.isEmpty) {
    return null;
  } else {
    return nom;
  }
}
