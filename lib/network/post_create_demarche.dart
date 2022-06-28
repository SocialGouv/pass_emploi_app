import 'package:pass_emploi_app/network/json_serializable.dart';

class PostCreateDemarchePersonnalisee implements JsonSerializable {
  final String commentaire;
  final DateTime dateEcheance;

  PostCreateDemarchePersonnalisee(this.commentaire, this.dateEcheance);

  @override
  Map<String, dynamic> toJson() => {
        "description": commentaire,
        "dateFin": dateEcheance.toIso8601String(),
      };
}

class PostCreateDemarche implements JsonSerializable {
  final String codeQuoi;
  final String codePourquoi;
  final String? codeComment;
  final DateTime dateEcheance;

  PostCreateDemarche({
    required this.codeQuoi,
    required this.codePourquoi,
    required this.codeComment,
    required this.dateEcheance,
  });

  @override
  Map<String, dynamic> toJson() => {
        "codeQuoi": codeQuoi,
        "codePourquoi": codePourquoi,
        if (codeComment != null) "codeComment": codeComment,
        "dateFin": dateEcheance.toIso8601String(),
      };
}
