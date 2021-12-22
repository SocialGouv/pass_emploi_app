import 'package:equatable/equatable.dart';

enum LocationType { COMMUNE, DEPARTMENT }

class Location extends Equatable {
  final String libelle;
  final String code;
  final LocationType type;
  final String? codePostal;
  final double? latitude;
  final double? longitude;

  Location({
    required this.libelle,
    required this.code,
    required this.type,
    this.codePostal,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(dynamic json) {
    return Location(
      libelle: json['libelle'],
      code: json['code'],
      type: _extractLocationType(json),
      codePostal: json['codePostal'],
      latitude: json['latitude'] != null ? json['latitude'] as double : null,
      longitude: json['longitude'] != null ? json['longitude'] as double : null,
    );
  }

  @override
  List<Object?> get props => [libelle, code, type, codePostal, latitude, longitude];
}

LocationType _extractLocationType(json) {
  return (json["type"]) == "DEPARTEMENT" ? LocationType.DEPARTMENT : LocationType.COMMUNE;
}
