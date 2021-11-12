import 'package:equatable/equatable.dart';

class OffreEmploi extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String location;

  OffreEmploi({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.location,
  });

  factory OffreEmploi.fromJson(dynamic json) {
    return OffreEmploi(
      id: json["id"] as String,
      title: json["titre"] as String,
      companyName: json["nomEntreprise"] as String?,
      contractType: json["typeContrat"] as String,
      location: json["localisation"]["nom"] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, companyName, contractType, location];
}
