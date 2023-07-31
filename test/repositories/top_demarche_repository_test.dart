import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/top_demarche_repository.dart';

void main() {
  group('TopDemarcheRepository', () {
    group('getTopDemarches', () {
      test('should return a list of demarches du referentiel', () {
        // Given
        final repository = TopDemarcheRepository();

        // When
        final result = repository.getTopDemarches();

        // Then
        expect(result, isA<List<DemarcheDuReferentiel>>());
      });
    });
  });
}
