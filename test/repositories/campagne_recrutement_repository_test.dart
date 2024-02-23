import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/remote_config/campagne_recrutement_config.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  void withAnyRead(String? value) {
    when(() => read(key: any(named: "key"))).thenAnswer((_) async => value);
  }
}

class MockCampagneRecrutementConfig extends Mock implements CampagneRecrutementConfig {
  void withLastCampagneId(String value) {
    when(() => lastCampagneId()).thenReturn(value);
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
      group('shouldShowCampagneRecrutement', () {
        test('should not show campgane recrutement on first read', () async {
          // Given
          const String campagneId = "campagneId";
          mockCampagneRecrutementConfig.withLastCampagneId(campagneId);
          mockFlutterSecureStorage.withAnyRead(null);

          // When
          final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

          // Then
          expect(result, false);
        });

        test('should not show campgane recrutement when campagneId is already registered', () async {
          // Given
          const String campagneId = "campagneId";
          mockCampagneRecrutementConfig.withLastCampagneId(campagneId);
          mockFlutterSecureStorage.withAnyRead(campagneId);

          // When
          final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

          // Then
          expect(result, false);
        });

        test('should show campgane recrutement when campagneId in different', () async {
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
}
