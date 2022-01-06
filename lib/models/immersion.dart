import 'package:equatable/equatable.dart';

class Immersion extends Equatable {
  final String id;
  final String metier;
  final String nomEtablissement;
  final String secteurActivite;
  final String ville;

  Immersion({
    required this.id,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
  });

  factory Immersion.fromJson(dynamic json) {
    return Immersion(
      id: json['id'],
      metier: json['metier'],
      nomEtablissement: json['nomEtablissement'],
      secteurActivite: json['secteurActivite'],
      ville: json['ville'],
    );
  }

  @override
  List<Object?> get props => [id, metier, nomEtablissement, secteurActivite, ville];
}
