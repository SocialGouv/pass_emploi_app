import 'package:equatable/equatable.dart';

class Immersion extends Equatable {
  final String id;
  final String metier;
  final String nomEtablissement;
  final String secteurActivite;
  final String ville;
  final bool fromEntrepriseAccueillante;

  Immersion({
    required this.id,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
    this.fromEntrepriseAccueillante = false,
  });

  factory Immersion.fromJson(dynamic json) {
    return Immersion(
      id: json['id'] as String,
      metier: json['metier'] as String,
      nomEtablissement: json['nomEtablissement'] as String,
      secteurActivite: json['secteurActivite'] as String,
      ville: json['ville'] as String,
      fromEntrepriseAccueillante: json['estVolontaire'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "metier": metier,
      "nomEtablissement": nomEtablissement,
      "secteurActivite": secteurActivite,
      "ville": ville,
      "estVolontaire": fromEntrepriseAccueillante,
    };
  }

  @override
  List<Object?> get props => [id, metier, nomEtablissement, secteurActivite, ville, fromEntrepriseAccueillante];
}
