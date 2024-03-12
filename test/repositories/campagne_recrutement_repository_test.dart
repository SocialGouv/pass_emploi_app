import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/campagne_recrutement_repository.dart';

import '../doubles/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late MockRemoteConfigRepository remoteConfigRepository;
  late CampagneRecrutementRepository campagneRecrutementRepository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    remoteConfigRepository = MockRemoteConfigRepository();
    campagneRecrutementRepository = CampagneRecrutementRepository(remoteConfigRepository, mockFlutterSecureStorage);
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
        when(() => remoteConfigRepository.lastCampagneRecrutementId()).thenReturn(null);
        mockFlutterSecureStorage.withAnyRead("campagneId");

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, false);
      });

      test('should not show campagne recrutement local and remote campagne are equals', () async {
        // Given
        const String campagneId = "campagneId";
        when(() => remoteConfigRepository.lastCampagneRecrutementId()).thenReturn(campagneId);
        mockFlutterSecureStorage.withAnyRead(campagneId);

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, false);
      });

      test('should show campagne recrutement when campagneId is different', () async {
        // Given
        const String campagneId = "campagneId";
        when(() => remoteConfigRepository.lastCampagneRecrutementId()).thenReturn(campagneId);
        mockFlutterSecureStorage.withAnyRead("anyCampagneId");

        // When
        final result = await campagneRecrutementRepository.shouldShowCampagneRecrutement();

        // Then
        expect(result, true);
      });
    });
  });
}
