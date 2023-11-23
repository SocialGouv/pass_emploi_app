import 'package:pass_emploi_app/network/json_serializable.dart';

class PostImmersionAlerte implements JsonSerializable {
  final String title;
  final String metier;
  final String localisation;
  final String? codeRome;
  final double? lat;
  final double? lon;
  final int? distance;

  PostImmersionAlerte({
    required this.title,
    required this.metier,
    required this.localisation,
    required this.codeRome,
    required this.lat,
    required this.lon,
    required this.distance,
  });

  @override
  Map<String, dynamic> toJson() => {
        "titre": title,
        "metier": metier,
        "localisation": localisation,
        "criteres": {
          "rome": codeRome,
          "lat": lat,
          "lon": lon,
          "distance": distance,
        }
      };
}
