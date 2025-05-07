import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/repositories/onboarding_repository.dart';

import '../doubles/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late OnboardingRepository onboardingRepository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    onboardingRepository = OnboardingRepository(mockFlutterSecureStorage);
  });

  group('OnboardingRepository', () {
    test('should initialize onboarding with all values true', () {
      // When
      final onboarding = Onboarding.initial();

      // Then
      expect(onboarding.showOnboarding, isTrue);
      expect(onboarding.showNotificationsOnboarding, isTrue);
    });

    group('save', () {
      test('should save onboarding with new properties', () async {
        // Given
        final onboarding = Onboarding();

        // When
        await onboardingRepository.save(onboarding);

        // Then
        final expectedJson = jsonEncode({
          'showAccueilOnboarding': true,
          'showNotificationsOnboarding': true,
          'showOnboarding': true,
        });
        verify(() => mockFlutterSecureStorage.write(key: 'onboardingStatus', value: expectedJson));
      });
    });

    group('get', () {
      test('should get onboarding with default values from legacy key', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead(_jsonOnboarding);

        // When
        final onboarding = await onboardingRepository.get();

        // Then
        expect(onboarding.showOnboarding, isTrue);
        expect(onboarding.showNotificationsOnboarding, isTrue);
      });

      test('should get onboarding with all keys present', () async {
        // Given
        final json = jsonEncode({
          'showAccueilOnboarding': true,
          'showNotificationsOnboarding': false,
          'showOnboarding': true,
        });
        mockFlutterSecureStorage.withAnyRead(json);

        // When
        final onboarding = await onboardingRepository.get();

        // Then
        expect(onboarding.showNotificationsOnboarding, isFalse);
        expect(onboarding.showOnboarding, isTrue);
      });

      test('should not show onboarding for old user (showAccueilOnboarding = false)', () async {
        // Given
        final json = jsonEncode({'showAccueilOnboarding': false});
        mockFlutterSecureStorage.withAnyRead(json);

        // When
        final onboarding = await onboardingRepository.get();

        // Then
        expect(onboarding.showOnboarding, isFalse);
        expect(onboarding.showNotificationsOnboarding, isFalse);
      });
    });
  });
}

final _jsonOnboarding = jsonEncode({'showAccueilOnboarding': true});
