import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';

class MatchingDemarcheDuReferentiel extends Equatable {
  final ThematiqueDeDemarche thematique;
  final DemarcheDuReferentiel demarcheDuReferentiel;
  final Comment? comment;

  MatchingDemarcheDuReferentiel({
    required this.demarcheDuReferentiel,
    required this.thematique,
    this.comment,
  });

  @override
  List<Object?> get props => [thematique, demarcheDuReferentiel, comment];
}
