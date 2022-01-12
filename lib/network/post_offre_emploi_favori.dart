import 'json_serializable.dart';

class PostOffreEmploiFavori implements JsonSerializable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final bool isAlternance;
  final String? location;
  final String? duration;

  PostOffreEmploiFavori(
    this.id,
    this.title,
    this.companyName,
    this.contractType,
    this.isAlternance,
    this.location,
    this.duration,
  );

  @override
  Map<String, dynamic> toJson() =>
      {
        "idOffre": id,
        "titre": title,
        "typeContrat": contractType,
        "nomEntreprise": companyName,
        "localisation": {
          "nom": location,
        },
        "alternance": isAlternance,
        "duree": duration,
      };
}
