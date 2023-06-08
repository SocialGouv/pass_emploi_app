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
      libelle: json['libelle'] as String,
      code: json['code'] as String,
      type: json["type"] == "DEPARTEMENT" ? LocationType.DEPARTMENT : LocationType.COMMUNE,
      codePostal: json['codePostal'] as String?,
      latitude: json['latitude'] != null ? json['latitude'] as double : null,
      longitude: json['longitude'] != null ? json['longitude'] as double : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'libelle': libelle,
        'code': code,
        'type': type == LocationType.DEPARTMENT ? "DEPARTEMENT" : "COMMUNE",
        if (codePostal != null) 'codePostal': codePostal,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };

  @override
  List<Object?> get props => [libelle, code, type, codePostal, latitude, longitude];
}
