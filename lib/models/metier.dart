import 'package:equatable/equatable.dart';

class Metier extends Equatable {
  final String codeRome;
  final String libelle;

  Metier({required this.codeRome, required this.libelle});

  factory Metier.fromJson(dynamic json) {
    return Metier(
      codeRome: json["code"] as String,
      libelle: json["libelle"] as String,
    );
  }

  factory Metier.conduiteEngin() {
    return Metier(codeRome: "A1101", libelle: "Conduite d'engins agricoles et forestiers");
  }

  @override
  List<Object?> get props => [codeRome, libelle];

  @override
  String toString() => libelle;
}
