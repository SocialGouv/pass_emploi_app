import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/matching_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

import '../doubles/fixtures.dart';

void main() {
  late MatchingDemarcheRepository matchingDemarcheRepository;
  late MockThematiqueDemarcheRepository thematiqueDemarcheRepository;

  setUp(() {
    thematiqueDemarcheRepository = MockThematiqueDemarcheRepository();
    matchingDemarcheRepository = MatchingDemarcheRepository(thematiqueDemarcheRepository);
  });

  group('getMatchingDemarcheDuReferentiel', () {
    test('should return null when getThematique fails', () async {
      // Given
      final demarche = mockDemarche(id: 'id');
      thematiqueDemarcheRepository.withThematiquesFailure();

      // When
      final result = await matchingDemarcheRepository.getMatchingDemarcheDuReferentiel(demarche);

      // Then
      expect(result, isNull);
    });

    test('should return null when there is no match in referentiel', () async {
      // Given
      final demarche = mockDemarche(id: 'id');
      final demarcheDuReferentiel = mockDemarcheDuReferentiel('id');
      thematiqueDemarcheRepository.withThematiquesSuccess(demarcheDuReferentiel);

      // When
      final result = await matchingDemarcheRepository.getMatchingDemarcheDuReferentiel(demarche);

      // Then
      expect(result, isNull);
    });

    test('should return a demarche du referentiel when there is a match', () async {
      // Given
      final comment = Comment(label: 'label1', code: 'code1');
      final demarcheDuReferentiel = mockDemarcheDuReferentiel('id', [comment]);

      final demarche = mockDemarche(id: 'id', titre: demarcheDuReferentiel.quoi, sousTitre: comment.label);
      thematiqueDemarcheRepository.withThematiquesSuccess(demarcheDuReferentiel);

      // When
      final result = await matchingDemarcheRepository.getMatchingDemarcheDuReferentiel(demarche);

      // Then
      expect(
        result,
        MatchingDemarcheDuReferentiel(
          thematique: dummyThematiqueDeDemarche([demarcheDuReferentiel]),
          demarcheDuReferentiel: demarcheDuReferentiel,
          comment: comment,
        ),
      );
    });
  });
}

class MockThematiqueDemarcheRepository extends Mock implements ThematiqueDemarcheRepository {
  void withThematiquesSuccess(DemarcheDuReferentiel demarcheDuReferentiel) {
    when(() => getThematique()).thenAnswer((_) async => [
          dummyThematiqueDeDemarche([demarcheDuReferentiel])
        ]);
  }

  void withThematiquesFailure() {
    when(() => getThematique()).thenAnswer((_) async => null);
  }
}
