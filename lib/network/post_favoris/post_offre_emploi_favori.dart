import 'package:pass_emploi_app/network/json_serializable.dart';

class PostOffreEmploiFavori implements JsonSerializable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final bool isAlternance;
  final String? location;
  final String? duration;
  final String? originName;
  final String? originLogo;

  PostOffreEmploiFavori(
    this.id,
    this.title,
    this.companyName,
    this.contractType,
    this.isAlternance,
    this.location,
    this.duration,
    this.originName,
    this.originLogo,
  );

  @override
  Map<String, dynamic> toJson() => {
        "idOffre": id,
        "titre": title,
        "typeContrat": contractType,
        "nomEntreprise": companyName,
        "localisation": {
          "nom": location,
        },
        "alternance": isAlternance,
        "duree": duration,
        "origineNom": originName,
        "origineLogo": originLogo,
      };
}
