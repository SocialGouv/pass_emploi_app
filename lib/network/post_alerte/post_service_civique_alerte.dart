import 'package:pass_emploi_app/network/json_serializable.dart';

class PostServiceCiviqueAlerte implements JsonSerializable {
  final String titre;
  final String? localisation;
  final double? lat;
  final double? lon;
  final int? distance;
  final String? dateDeDebutMinimum;
  final String? domaine;

  PostServiceCiviqueAlerte({
    required this.titre,
    required this.localisation,
    required this.lat,
    required this.lon,
    required this.distance,
    required this.dateDeDebutMinimum,
    required this.domaine,
  });

  @override
  Map<String, dynamic> toJson() => {
    "titre": titre,
    "localisation": localisation,
    "criteres": {
      "lat": lat,
      "lon": lon,
      "distance": distance,
      "dateDeDebutMinimum": dateDeDebutMinimum,
      "domaine": domaine,
    }
  };
}
