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

  @override
  List<Object?> get props => [codeRome, libelle];

  @override
  String toString() => libelle;
}
