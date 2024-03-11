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
    group('save', () {
      test('should save onboarding', () async {
        // Given
        final Onboarding onboarding = Onboarding();

        // When
        await onboardingRepository.save(onboarding);

        // Then
        verify(() => mockFlutterSecureStorage.write(key: 'onboardingStatus', value: _jsonOnboarding));
      });
    });

    group('get', () {
      test('should get onboarding', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead(_jsonOnboarding);

        // When
        final onboarding = await onboardingRepository.get();

        // Then
        expect(onboarding, Onboarding(showAccueilOnboarding: true));
      });
    });
  });
}

final _jsonOnboarding = jsonEncode({
  'showAccueilOnboarding': true,
  'showMonSuiviOnboarding': true,
  'showChatOnboarding': true,
  'showRechercheOnboarding': true,
  'showEvenementsOnboarding': true,
});
