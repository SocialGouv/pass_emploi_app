import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/remote_config/campagne_recrutement_config.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';

import '../doubles/mocks.dart';

class MockCampagneRecrutementConfig extends Mock implements CampagneRecrutementRemoteConfig {
  void withLastCampagneId(String? value) {
    when(() => lastCampagneId()).thenReturn(value);
  }
}

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockCampagneRecrutementConfig mockCampagneRecrutementConfig;
  late CampagneRecrutementRepository campagneRecrutementRepository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    mockCampagneRecrutementConfig = MockCampagneRecrutementConfig();
    campagneRecrutementRepository =
        CampagneRecrutementRepository(mockFlutterSecureStorage, mockCampagneRecrutementConfig);
  });

  group('CampagneRecrutementRepository', () {
    group('isFirstLaunch', () {
      test('should return true on first read', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead(null);

        // When
        final result = await campagneRecrutementRepository.isFirstLaunch();

        // Then
        expect(result, true);
      });

      test('should return false on second read', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead("anyValue");

        // When
        final result = await campagneRecrutementRepository.isFirstLaunch();

        // Then
        expect(result, false);
      });
    });

    group('shouldShowCampagneRecrutement', () {
      test('should not show campagne recrutement if campagneConfig is null', () async {
        // Given
        mockCampagneRecrutementConfig.withLastCampagneId(null);
        mockFlutterSecureStorage.withAnyRead("campagneId");

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, false);
      });

      test('should not show campagne recrutement local and remote campagne are equals', () async {
        // Given
        const String campagneId = "campagneId";
        mockCampagneRecrutementConfig.withLastCampagneId(campagneId);
        mockFlutterSecureStorage.withAnyRead(campagneId);

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, false);
      });

      test('should show campagne recrutement when campagneId is different', () async {
        // Given
        const String campagneId = "campagneId";
        mockCampagneRecrutementConfig.withLastCampagneId(campagneId);
        mockFlutterSecureStorage.withAnyRead("anyCampagneId");

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, true);
      });
    });
  });
}
