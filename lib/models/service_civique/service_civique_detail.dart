import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class ServiceCiviqueDetail extends Equatable {
  final String id;
  final String titre;
  final String dateDeDebut;
  final String domaine;
  final String ville;
  final String organisation;
  final String? dateDeFin;
  final String? lienAnnonce;
  final String? urlOrganisation;
  final String? adresseMission;
  final String? adresseOrganisation;
  final String? codeDepartement;
  final String? description;
  final String? descriptionOrganisation;
  final String? codePostal;

  ServiceCiviqueDetail({
    required this.id,
    required this.titre,
    required this.dateDeDebut,
    required this.dateDeFin,
    required this.domaine,
    required this.ville,
    required this.organisation,
    required this.lienAnnonce,
    required this.urlOrganisation,
    required this.adresseMission,
    required this.adresseOrganisation,
    required this.codeDepartement,
    required this.description,
    required this.descriptionOrganisation,
    required this.codePostal,
  });

  factory ServiceCiviqueDetail.fromJson(dynamic json, String id) {
    final String? stringDateDebut = (json["dateDeDebut"] as String?);
    final String? stringDateFin = (json["dateDeFin"] as String?);
    return ServiceCiviqueDetail(
      id: id,
      titre: json["titre"] as String,
      dateDeDebut: stringDateDebut!.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth(),
      dateDeFin: stringDateFin?.toDateTimeUtcOnLocalTimeZone().toDayWithFullMonth(),
      domaine: json["domaine"] as String,
      ville: json["ville"] as String,
      organisation: json["organisation"] as String,
      lienAnnonce: json["lienAnnonce"] as String?,
      urlOrganisation: json["urlOrganisation"] as String?,
      adresseMission: json["adresseMission"] as String?,
      adresseOrganisation: json["adresseOrganisation"] as String?,
      codeDepartement: _codeDepartment(json["codeDepartement"]),
      description: json["description"] as String?,
      descriptionOrganisation: json["descriptionOrganisation"] as String?,
      codePostal: json["codePostal"] as String?,
    );
  }

  @override
  List<Object?> get props => [
        titre,
        dateDeDebut,
        domaine,
        ville,
        organisation,
        dateDeFin,
        lienAnnonce,
        urlOrganisation,
        adresseMission,
        adresseOrganisation,
        codeDepartement,
        description,
        descriptionOrganisation,
        codePostal,
      ];
}

String? _codeDepartment(dynamic codeFromJson) {
  if (codeFromJson is String) return codeFromJson;
  if (codeFromJson is int) return codeFromJson.toString();
  return null;
}

extension ServiceCiviqueDetailExt on ServiceCiviqueDetail {
  ServiceCivique get toServiceCivique {
    return ServiceCivique(
      id: id,
      title: titre,
      domain: domaine,
      companyName: organisation,
      location: ville,
      startDate: dateDeDebut,
    );
  }
}
