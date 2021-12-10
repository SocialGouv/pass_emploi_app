import 'package:equatable/equatable.dart';

enum LocationType { COMMUNE, DEPARTMENT }

class Location extends Equatable {
  final String libelle;
  final String code;
  final String codePostal;
  final LocationType type;

  Location({
    required this.libelle,
    required this.code,
    required this.codePostal,
    required this.type,
  });

  factory Location.fromJson(dynamic json) {
    return Location(
      libelle: json['libelle'] as String,
      code: json['code'] as String,
      codePostal: json['codePostal'] as String,
      type: _extractLocationType(json),
    );
  }

  @override
  String toString() {
    return '$libelle ($code)';
  }

  @override
  List<Object?> get props => [libelle, code, codePostal, type];
}

LocationType _extractLocationType(json) {
  return (json["type"] as String) == "DEPARTEMENT" ? LocationType.DEPARTMENT : LocationType.COMMUNE;
}
