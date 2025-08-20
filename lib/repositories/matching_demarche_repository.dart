import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

class MatchingDemarcheRepository {
  final ThematiqueDemarcheRepository thematiquesRepository;

  MatchingDemarcheRepository(this.thematiquesRepository);

  Future<MatchingDemarcheDuReferentiel?> getMatchingDemarcheDuReferentiel(Demarche demarche) async {
    final thematiques = await thematiquesRepository.getThematique();
    if (thematiques == null) return null;

    for (final thematique in thematiques) {
      final matchingDemarche = thematique.demarches
          .firstWhereOrNull((demarcheDuReferentiel) => demarcheDuReferentiel.quoi == demarche.titre);
      if (matchingDemarche == null) continue;

      return MatchingDemarcheDuReferentiel(
        thematique: thematique,
        demarcheDuReferentiel: matchingDemarche,
        comment: matchingDemarche.comments.firstWhereOrNull((comment) => comment.label == demarche.sousTitre),
      );
    }
    return null;
  }

  Future<MatchingDemarcheDuReferentiel?> getMatchingDemarcheDuReferentielFromCode({required String? codeQuoi}) async {
    final thematiques = await thematiquesRepository.getThematique();
    if (thematiques == null) return null;

    for (final thematique in thematiques) {
      final matchingDemarche =
          thematique.demarches.firstWhereOrNull((demarcheDuReferentiel) => demarcheDuReferentiel.codeQuoi == codeQuoi);
      if (matchingDemarche == null) continue;

      return MatchingDemarcheDuReferentiel(
        thematique: thematique,
        demarcheDuReferentiel: matchingDemarche,
      );
    }
    return null;
  }
}
