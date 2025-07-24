import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/boulanger_campagne_repository.dart';

import '../doubles/spies.dart';

void main() {
  group('BoulangerCampagneRepository', () {
    late FlutterSecureStorageSpy secureStorage;
    late BoulangerCampagneRepository repository;
    late Clock clock;

    setUp(() {
      secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    });

    test('should return false if already saved', () async {
      // Given
      clock = Clock.fixed(DateTime(2025, 6, 1));
      repository = BoulangerCampagneRepository(secureStorage, clock: clock);

      // When
      await repository.save();
      final result = await repository.get();

      // Then
      expect(result, false);
    });

    test('should return true if the date is before the 15th of september 2025', () async {
      // Given
      clock = Clock.fixed(DateTime(2025, 6, 1));
      repository = BoulangerCampagneRepository(secureStorage, clock: clock);

      // When
      final result = await repository.get();

      // Then
      expect(result, true);
    });

    test('should return false if the date is after the 15th of september 2025', () async {
      // Given
      clock = Clock.fixed(DateTime(2025, 9, 16));
      repository = BoulangerCampagneRepository(secureStorage, clock: clock);

      // When
      final result = await repository.get();

      // Then
      expect(result, false);
    });
  });
}
