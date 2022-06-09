import 'package:pass_emploi_app/network/json_serializable.dart';

class PostCreateDemarche implements JsonSerializable {
  final String commentaire;
  final DateTime dateEcheance;

  PostCreateDemarche(this.commentaire, this.dateEcheance);

  @override
  Map<String, dynamic> toJson() => {
        "description": commentaire,
        "dateFin": dateEcheance.toIso8601String(),
      };
}
