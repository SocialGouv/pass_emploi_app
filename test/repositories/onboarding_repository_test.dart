import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
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
        final Onboarding onboarding = Onboarding(showAccueilOnboarding: true);

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

const _jsonOnboarding = '{"showAccueilOnboarding":true}';
