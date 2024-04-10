import 'package:pass_emploi_app/network/json_serializable.dart';

class PostPieceJointe implements JsonSerializable {
  final String fichier;
  final String? nom;

  PostPieceJointe({
    required this.fichier,
    required this.nom,
  });

  @override
  Map<String, dynamic> toJson() => {
        "fichier": fichier,
        "nom": nom,
      };
}
