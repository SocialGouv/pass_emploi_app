import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/json_serializable.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class PostOffreEmploiFavori implements JsonSerializable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final bool isAlternance;
  final String? location;
  final String? duration;
  final Origin? origin;
  final bool applied;

  PostOffreEmploiFavori(
    this.id,
    this.title,
    this.companyName,
    this.contractType,
    this.isAlternance,
    this.location,
    this.duration,
    this.origin,
    this.applied,
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
        if (origin is FranceTravailOrigin) "origineNom": Strings.franceTravail,
        if (origin is PartenaireOrigin) "origineNom": (origin! as PartenaireOrigin).name,
        if (origin is PartenaireOrigin) "origineLogo": (origin! as PartenaireOrigin).logoUrl,
        "aPostule": applied,
      };
}
