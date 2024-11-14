import 'package:equatable/equatable.dart';

class OffreEmploi extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final bool isAlternance;
  final String? location;
  final String? duration;

  OffreEmploi({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.isAlternance,
    required this.location,
    required this.duration,
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
    };
  }

  @override
  List<Object?> get props => [id, title, companyName, contractType, isAlternance, location, duration];
}

String? _getLocation(dynamic json) {
  final nom = (json["localisation"]["nom"] as String?);
  if (nom == null || nom.isEmpty) {
    return null;
  } else {
    return nom;
  }
}
