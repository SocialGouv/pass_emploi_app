import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/derniere_offre_consultee.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late DerniereOffreConsulteeRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    repository = DerniereOffreConsulteeRepository(secureStorage);
  });

  group('offre emploi', () {
    test('should set and get', () async {
      // Given
      final offre = DerniereRechercheOffreEmploi(mockOffreEmploi());
      await repository.set(offre);

      // When
      final result = await repository.get();

      // Then
      expect(result, offre);
    });
  });

  group('immersion', () {
    test('should set and get', () async {
      // Given
      final offre = DerniereRechercheImmersion(mockImmersion());
      await repository.set(offre);

      // When
      final result = await repository.get();

      // Then
      expect(result, offre);
    });
  });

  group('service civique', () {
    test('should set and get', () async {
      // Given
      final offre = DerniereRechercheServiceCivique(mockServiceCivique());
      await repository.set(offre);

      // When
      final result = await repository.get();

      // Then
      expect(result, offre);
    });
  });
}
