import 'package:pass_emploi_app/network/json_serializable.dart';

class PostImmersionFavori implements JsonSerializable {
  final String id;
  final String metier;
  final String nomEtablissement;
  final String secteurActivite;
  final String ville;

  PostImmersionFavori({
    required this.id,
    required this.metier,
    required this.nomEtablissement,
    required this.secteurActivite,
    required this.ville,
  });

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "metier": metier,
        "nomEtablissement": nomEtablissement,
        "secteurActivite": secteurActivite,
        "ville": ville,
      };
}
