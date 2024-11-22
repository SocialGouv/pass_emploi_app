import 'package:clock/clock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/models/feedback_for_feature.dart';
import 'package:pass_emploi_app/repositories/in_app_feedback_repository.dart';

import '../doubles/mocks.dart';
import '../doubles/spies.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late MockRemoteConfigRepository remoteConfigRepository;
  late InAppFeedbackRepository repository;

  setUp(() {
    // Because of strange issue in withClock method of clock package, we cannot add a delay to the spy
    // https://github.com/dart-lang/tools/issues/699
    secureStorage = FlutterSecureStorageSpy(delay: Duration.zero);
    remoteConfigRepository = MockRemoteConfigRepository();
    repository = InAppFeedbackRepository(secureStorage, remoteConfigRepository);
  });

  group('InAppFeedbackRepository', () {
    group('isFeedbackActivated', () {
      test('if absent from remote configuration should return false', () async {
        // Given
        when(() => remoteConfigRepository.inAppFeedbackForFeature('feature-1')).thenReturn(null);

        // When
        final result = await repository.isFeedbackActivated('feature-1');

        // Then
        expect(result, isFalse);
      });

      test('if present from remote configuration but campaign is past should return false', () {
        final now = DateTime(2024, 1, 3);
        withClock(Clock.fixed(now), () async {
          // Given
          when(() => remoteConfigRepository.inAppFeedbackForFeature('feature-1'))
              .thenReturn(FeedbackForFeature(0, DateTime(2024, 1, 1)));

          // When
          final result = await repository.isFeedbackActivated('feature-1');

          // Then
          expect(result, isFalse);
        });
      });

      test('if present from remote configuration, campaign is in progress, but not enough display should return false',
          () {
        final now = DateTime(2024, 1, 3);
        withClock(Clock.fixed(now), () async {
          // Given
          await _givenFeatureDisplayed(secureStorage, 'feature-1', 1);
          when(() => remoteConfigRepository.inAppFeedbackForFeature('feature-1'))
              .thenReturn(FeedbackForFeature(3, DateTime(2024, 1, 4)));

          // When
          final result = await repository.isFeedbackActivated('feature-1');

          // Then
          expect(result, isFalse);
        });
      });

      test('if present from remote configuration, campaign is in progress, and enough display should return true', () {
        final now = DateTime(2024, 1, 3);
        withClock(Clock.fixed(now), () async {
          // Given
          await _givenFeatureDisplayed(secureStorage, 'feature-1', 3);
          when(() => remoteConfigRepository.inAppFeedbackForFeature('feature-1'))
              .thenReturn(FeedbackForFeature(2, DateTime(2024, 1, 4)));

          // When
          final result = await repository.isFeedbackActivated('feature-1');

          // Then
          expect(result, isTrue);
        });
      });
    });

    group('dismissFeedback', () {
      test('should store an unreachable display count to disable feedback activation', () async {
        // Given
        await _givenFeatureDisplayed(secureStorage, 'feature-1', 3);
        await repository.dismissFeedback('feature-1');

        // When
        final result = await secureStorage.read(key: 'display-count-for-feature-feature-1');

        // Then
        expect(result, isNotNull);
        expect(int.parse(result!), lessThan(-10000));
      });
    });
  });
}

Future<void> _givenFeatureDisplayed(FlutterSecureStorage secureStorage, String feature, int display) async {
  await secureStorage.write(key: 'display-count-for-feature-$feature', value: display.toString());
}
