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
    group('seen', () {
      test('should save first launch onboarding', () async {
        // When
        await onboardingRepository.seen();

        // Then
        verify(() => mockFlutterSecureStorage.write(key: 'firstLaunchOnboarding', value: 'seen'));
      });
    });

    group('showFirstLaunchOnboarding', () {
      test('when already seen', () async {
        // Given
        mockFlutterSecureStorage.withAnyRead("seen");

        // When
        final onboarding = await onboardingRepository.showFirstLaunchOnboarding();

        // Then
        expect(onboarding, false);
      });

      test('when not seen yet', () async {
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
