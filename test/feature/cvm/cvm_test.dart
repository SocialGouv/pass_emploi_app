import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  late MockCvmBridge bridge;
  late MockCvmLastReadingRepository lastReadingRepository;

  setUp(() {
    bridge = MockCvmBridge();
    lastReadingRepository = MockCvmLastReadingRepository();
  });

  group('Cvm', () {
    final sut = StoreSut();

    test('sendMessage', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store((f) => {f.cvmBridge = bridge});

      // When
      store.dispatch(CvmSendMessageAction('message'));

      // Then
      verify(() => bridge.sendMessage('message')).called(1);
    });

    test('loadMore', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store((f) => {f.cvmBridge = bridge});

      // When
      store.dispatch(CvmLoadMoreAction());

      // Then
      verify(() => bridge.loadMore()).called(1);
    });

    group('logout', () {
      test('when CVM state is init', () async {
        // Given
        final store = givenState() //
            .loggedInPoleEmploiUser()
            .withCvmMessage()
            .store((f) => {f.cvmBridge = bridge});
        when(() => bridge.logout()).thenAnswer((_) async {});

        // When
        await store.dispatch(RequestLogoutAction(LogoutReason.userLogout));

        // Then
        verify(() => bridge.logout()).called(1);
      });

      test('when CVM state is not init', () async {
        // Given
        final store = givenState() //
            .loggedInPoleEmploiUser()
            .store((f) => {f.cvmBridge = bridge});

        // When
        await store.dispatch(RequestLogoutAction(LogoutReason.userLogout));

        // Then
        verifyNever(() => bridge.logout());
      });
    });

    group('Chat status', () {
      group('when has messages from conseiller', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022), sentBy: Sender.conseiller),
          ]),
        );

        test('and no jeune last reading', () {
          when(() => lastReadingRepository.getLastJeuneReading()).thenAnswer((_) async => null);

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectChangingStatesThroughOrder([_shouldHaveUnreadMessage(true)]);
        });

        test('and last jeune reading before last message conseiller', () {
          when(() => lastReadingRepository.getLastJeuneReading()).thenAnswer((_) async => DateTime(2021));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectChangingStatesThroughOrder([_shouldHaveUnreadMessage(true)]);
        });

        test('and last jeune reading after last message conseiller', () {
          when(() => lastReadingRepository.getLastJeuneReading()).thenAnswer((_) async => DateTime(2023));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectNever(_shouldHaveUnreadMessage(true));
        });
      });

      group('when has not any messages from conseiller', () {
        sut.whenDispatchingAction(() => CvmSuccessAction([mockCvmTextMessage(sentBy: Sender.jeune)]));

        test('should not update chat status', () {
          when(() => lastReadingRepository.getLastJeuneReading()).thenAnswer((_) async => DateTime(2020));

          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectNever(_shouldHaveUnreadMessage(true));
        });
      });
    });

    group('Last jeune reading', () {
      test('CvmLastReadingAction should save current date', () {
        final now = DateTime(2024);
        withClock(Clock.fixed(now), () {
          // Given
          final store = givenState().store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          // When
          store.dispatch(CvmLastJeuneReadingAction());

          // Then
          verify(() => lastReadingRepository.saveLastJeuneReading(now)).called(1);
        });
      });

      group('when updating last jeune reading value', () {
        sut.whenDispatchingAction(() => CvmLastJeuneReadingAction());

        test('should reset chat status', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .copyWith(
                chatStatusState: ChatStatusSuccessState(
                  hasUnreadMessages: true,
                  lastConseillerReading: DateTime(2020),
                ),
              )
              .store((f) => {f.cvmLastReadingRepository = lastReadingRepository});

          sut.thenExpectChangingStatesThroughOrder([_shouldResetChatStatus()]);
        });
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

Matcher _shouldResetChatStatus() => StateIs<ChatStatusEmptyState>((state) => state.chatStatusState);