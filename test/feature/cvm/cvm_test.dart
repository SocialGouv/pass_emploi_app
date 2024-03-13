import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late MockCvmLastReadingRepository lastReadingRepository;

  setUp(() {
    lastReadingRepository = MockCvmLastReadingRepository();
  });

  group('Cvm', () {
    final sut = StoreSut();

    group('Chat status', () {
      group('when has messages from conseiller', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022), sentBy: Sender.conseiller),
          ]),
        );

        test('and no last reading', () {
          when(() => lastReadingRepository.getLastReading()).thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectChangingStatesThroughOrder([_shouldHaveUnreadMessage(true)]);
        });

        test('and last reading before last message conseiller', () {
          when(() => lastReadingRepository.getLastReading()).thenAnswer((_) async => DateTime(2021));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectChangingStatesThroughOrder([_shouldHaveUnreadMessage(true)]);
        });

        test('and last reading after last message conseiller', () {
          when(() => lastReadingRepository.getLastReading()).thenAnswer((_) async => DateTime(2023));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectNever(_shouldHaveUnreadMessage(true));
        });
      });

      group('when has not any messages from conseiller', () {
        sut.whenDispatchingAction(() => CvmSuccessAction([mockCvmTextMessage(sentBy: Sender.jeune)]));

        test('should not update chat status', () {
          when(() => lastReadingRepository.getLastReading()).thenAnswer((_) async => DateTime(2020));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectNever(_shouldHaveUnreadMessage(true));
        });
      });
    });

    test('CvmLastReadingAction', () {
      final now = DateTime(2024);
      withClock(Clock.fixed(now), () async {
        // Given
        final store = givenState().store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

        // When
        await store.dispatch(CvmLastReadingAction());

        // Then
        verify(() => lastReadingRepository.saveLastReading(now)).called(1);
      });
    });
  });
}

Matcher _shouldHaveUnreadMessage(bool hasUnreadMessages) {
  return StateIs<ChatStatusSuccessState>(
    (state) => state.chatStatusState,
    (state) => expect(state.hasUnreadMessages, hasUnreadMessages),
  );
}
