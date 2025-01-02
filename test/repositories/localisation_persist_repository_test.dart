import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/localisation_persist_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late LocalisationPersistRepository repository;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    repository = LocalisationPersistRepository(secureStorage);
  });

  group('LocalisationPersistRepository', () {
    test('full integration test', () async {
      // Given
      await repository.save(mockLocation());

      // When
      final result = await repository.get();

      // Then
      expect(result, equals(mockLocation()));
    });
  });
}
