import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

class MatchingDemarcheRepository {
  final ThematiqueDemarcheRepository thematiquesRepository;

  MatchingDemarcheRepository(this.thematiquesRepository);

  Future<MatchingDemarcheDuReferentiel?> getMatchingDemarcheDuReferentiel(Demarche demarche) async {
    final thematiques = await thematiquesRepository.getThematique();

    if (thematiques != null) {
      DemarcheDuReferentiel? demarcheDuReferentiel;
      ThematiqueDeDemarche? thematiqueDuReferentiel;
      for (final thematique in thematiques) {
        thematiqueDuReferentiel = thematique;
        demarcheDuReferentiel = thematique.demarches
            .firstWhereOrNull((demarcheDuReferentiel) => demarcheDuReferentiel.quoi == demarche.titre);
        if (demarcheDuReferentiel != null) {
          final comment =
              demarcheDuReferentiel.comments.firstWhereOrNull((comment) => comment.label == demarche.sousTitre);
          return MatchingDemarcheDuReferentiel(
            thematique: thematiqueDuReferentiel,
            demarcheDuReferentiel: demarcheDuReferentiel,
            comment: comment,
          );
        }
      }
      return null;
    }
    return null;
  }
}
