import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/repositories/derniere_offre_consultee_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late DerniereOffreConsulteeRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    repository = DerniereOffreConsulteeRepository(secureStorage);
  });

  group('offre emploi', () {
    test('should set and get', () async {
      // Given
      final offre = OffreEmploiDto(mockOffreEmploi());
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
      final offre = OffreImmersionDto(mockImmersion());
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
      final offre = OffreServiceCiviqueDto(mockServiceCivique());
      await repository.set(offre);

      // When
      final result = await repository.get();

      // Then
      expect(result, offre);
    });
  });
}
