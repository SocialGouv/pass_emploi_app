import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';

class ThematiqueDeDemarche extends Equatable {
  final String code;
  final String libelle;
  final List<DemarcheDuReferentiel> demarches;

  ThematiqueDeDemarche({
    required this.code,
    required this.libelle,
    required this.demarches,
  });

  factory ThematiqueDeDemarche.fromJson(dynamic json) {
    return ThematiqueDeDemarche(
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      demarches: (json['demarches'] as List).map(DemarcheDuReferentiel.fromJson).toList(),
    );
  }

  @override
  List<Object?> get props => [code, libelle, demarches];
}
