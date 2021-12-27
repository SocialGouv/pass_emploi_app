import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';

class ImmersionDetails extends Equatable {
  final String id;
  final String metier;
  final String nomEtablissement;
  final String secteurActivite;
  final String ville;
  final String address;
  final bool isVolontaire;
  final ImmersionContact? contact;

  ImmersionDetails({
    required this.id,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
    required this.address,
    required this.isVolontaire,
    required this.contact,
  });

  factory ImmersionDetails.fromJson(dynamic json) {
    return ImmersionDetails(
      id: json['id'],
      metier: json['metier'],
      nomEtablissement: json['nomEtablissement'],
      secteurActivite: json['secteurActivite'],
      ville: json['ville'],
      address: json['adresse'],
      isVolontaire: json['estVolontaire'] as bool,
      contact: json['contact'] != null ? ImmersionContact.fromJson(json['contact']) : null,
    );
  }

  @override
  List<Object?> get props => [id, metier, nomEtablissement, secteurActivite, ville, address, isVolontaire, contact];
}
