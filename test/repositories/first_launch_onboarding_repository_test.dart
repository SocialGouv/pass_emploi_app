import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/first_launch_onboarding_repository.dart';

import '../doubles/mocks.dart';

void main() {
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late FirstLaunchOnboardingRepository onboardingRepository;

  setUp(() {
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    onboardingRepository = FirstLaunchOnboardingRepository(mockFlutterSecureStorage);
  });

  group('FirstLaunchOnboardingRepository', () {
    group('save', () {
      test('should save first launch onboarding', () async {
        // When
        await onboardingRepository.seen();

        // Then
        verify(() => mockFlutterSecureStorage.write(key: 'firstLaunchOnboarding', value: 'seen'));
      });
    });

    group('get', () {
      test('should get first launch onboarding', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead("seen");

        // When
        final onboarding = await onboardingRepository.showFirstLaunchOnboarding();

        // Then
        expect(onboarding, false);
      });

      test('should get first launch onboarding', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead(null);

        // When
        final onboarding = await onboardingRepository.showFirstLaunchOnboarding();

        // Then
        expect(onboarding, true);
      });
    });
  });
}
