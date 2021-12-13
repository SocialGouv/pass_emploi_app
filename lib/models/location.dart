import 'package:equatable/equatable.dart';

enum LocationType { COMMUNE, DEPARTMENT }

class Location extends Equatable {
  final String libelle;
  final String code;
  final String? codePostal;
  final LocationType type;

  Location({
    required this.libelle,
    required this.code,
    required this.codePostal,
    required this.type,
  });

  factory Location.fromJson(dynamic json) {
    return Location(
      libelle: json['libelle'],
      code: json['code'],
      codePostal: json['codePostal'],
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
  return (json["type"]) == "DEPARTEMENT" ? LocationType.DEPARTMENT : LocationType.COMMUNE;
}
