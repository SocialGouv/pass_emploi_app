import '../json_serializable.dart';

class PostImmersionSavedSearch implements JsonSerializable {
  final String title;
  final String metier;
  final String localisation;
  final String? codeRome;
  final double? lat;
  final double? lon;

  PostImmersionSavedSearch({
    required this.title,
    required this.metier,
    required this.localisation,
    required this.codeRome,
    required this.lat,
    required this.lon,
  });

  @override
  Map<String, dynamic> toJson() => {
        "titre": title,
        "metier": metier,
        "localisation": localisation,
        "criteres": {
          "rome": codeRome ?? "",
          "lat": lat ?? 0,
          "lon": lon ?? 0,
        }
      };
}
