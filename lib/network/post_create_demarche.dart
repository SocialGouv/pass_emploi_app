import 'package:pass_emploi_app/network/json_serializable.dart';

class PostCreateDemarchePersonnalisee implements JsonSerializable {
  final String commentaire;
  final DateTime dateEcheance;
  final bool estDuplicata;

  PostCreateDemarchePersonnalisee(this.commentaire, this.dateEcheance, this.estDuplicata);

  @override
  Map<String, dynamic> toJson() => {
        "description": commentaire,
        "dateFin": dateEcheance.toIso8601String(),
        "estDuplicata": estDuplicata,
      };
}

class PostCreateDemarche implements JsonSerializable {
  final String codeQuoi;
  final String codePourquoi;
  final String? codeComment;
  final DateTime dateEcheance;
  final bool estDuplicata;
  final bool genereParIA;
  final String? description;

  PostCreateDemarche({
    required this.codeQuoi,
    required this.codePourquoi,
    required this.codeComment,
    required this.dateEcheance,
    required this.estDuplicata,
    required this.genereParIA,
    this.description,
  });

  @override
  Map<String, dynamic> toJson() => {
        "codeQuoi": codeQuoi,
        "codePourquoi": codePourquoi,
        if (codeComment != null) "codeComment": codeComment,
        "dateFin": dateEcheance.toIso8601String(),
        "estDuplicata": estDuplicata,
        if (genereParIA) "genereParIA": genereParIA,
        if (description != null) "description": description,
      };
}
