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

  setUp(() {
    bridge = MockCvmBridge();
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
      group('when not any messages from conseiller with jeune last reading', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022), sentBy: Sender.conseiller, readByJeune: false),
          ]),
        );

        test('should have unread message', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectChangingStatesThroughOrder([_shouldHaveUnreadMessage(true)]);
        });
      });

      group('when message from conseiller with jeune last reading', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022), sentBy: Sender.conseiller, readByJeune: false),
            mockCvmTextMessage(date: DateTime(2023), sentBy: Sender.conseiller, readByJeune: true),
          ]),
        );

        test('should not have unread message', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectNever(_shouldHaveUnreadMessage(true));
        });
      });
    });

    group('when has not any messages from conseiller', () {
      sut.whenDispatchingAction(() => CvmSuccessAction([mockCvmTextMessage(sentBy: Sender.jeune)]));

      test('should not update chat status', () {
        sut.givenStore = givenState() //
            .loggedInPoleEmploiUser()
            .store();

        sut.thenExpectNever(_shouldHaveUnreadMessage(true));
      });
    });

    group('Last jeune reading', () {
      group('CvmLastReadingAction should mark last conseiller message as read', () {
        test('when last conseiller message is of type text', () {
          final now = DateTime(2024);
          withClock(Clock.fixed(now), () {
            // Given
            final store = givenState().withCvmMessage(messages: [
              mockCvmTextMessage(id: '1', date: now, sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '2', date: now.add(Duration(hours: 2)), sentBy: Sender.conseiller),
              mockCvmFileMessage(id: '3', date: now.add(Duration(hours: 3)), sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '4', date: now.add(Duration(hours: 4)), sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '5', date: now.add(Duration(hours: 5)), sentBy: Sender.jeune),
            ]).store((f) => {f.cvmBridge = bridge});
            when(() => bridge.markAsRead(any())).thenAnswer((_) async => true);

            // When
            store.dispatch(CvmLastJeuneReadingAction());

            // Then
            verify(() => bridge.markAsRead('4')).called(1);
          });
        });

        test('when last conseiller message is of type file', () {
          final now = DateTime(2024);
          withClock(Clock.fixed(now), () {
            // Given
            final store = givenState().withCvmMessage(messages: [
              mockCvmTextMessage(id: '1', date: now, sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '2', date: now.add(Duration(hours: 2)), sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '3', date: now.add(Duration(hours: 3)), sentBy: Sender.conseiller),
              mockCvmFileMessage(id: '7', date: now.add(Duration(hours: 7)), sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '10', date: now.add(Duration(hours: 10)), sentBy: Sender.jeune),
            ]).store((f) => {f.cvmBridge = bridge});
            when(() => bridge.markAsRead(any())).thenAnswer((_) async => true);

            // When
            store.dispatch(CvmLastJeuneReadingAction());

            // Then
            verify(() => bridge.markAsRead('7')).called(1);
          });
        });

        test('when last conseiller message is of type unknown', () {
          final now = DateTime(2024);
          withClock(Clock.fixed(now), () {
            // Given
            final store = givenState().withCvmMessage(messages: [
              mockCvmTextMessage(id: '1', date: now, sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '2', date: now.add(Duration(hours: 2)), sentBy: Sender.conseiller),
              mockCvmTextMessage(id: '3', date: now.add(Duration(hours: 3)), sentBy: Sender.conseiller),
              mockCvmUnknownMessage(id: '9', date: now.add(Duration(hours: 9))),
              mockCvmTextMessage(id: '10', date: now.add(Duration(hours: 10)), sentBy: Sender.jeune),
            ]).store((f) => {f.cvmBridge = bridge});
            when(() => bridge.markAsRead(any())).thenAnswer((_) async => true);

            // When
            store.dispatch(CvmLastJeuneReadingAction());

            // Then
            verify(() => bridge.markAsRead('9')).called(1);
          });
        });
      });

      group('when updating last jeune reading value', () {
        sut.whenDispatchingAction(() => CvmLastJeuneReadingAction());

        test('should update hasUnreadMessage', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .withCvmMessage(messages: [mockCvmTextMessage(date: DateTime(2022), sentBy: Sender.conseiller)])
              .copyWith(
                chatStatusState: ChatStatusSuccessState(
                  hasUnreadMessages: true,
                  lastConseillerReading: DateTime(2020),
                ),
              )
              .store();

          sut.thenExpectAtSomePoint(
            _shouldHaveChatStatus(hasUnreadMessages: false, lastConseillerReading: DateTime(2020)),
          );
        });
      });
    });

    group('Last conseiller reading', () {
      group('when a message is read from conseiller but no conseiller message', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022, 1, 1), sentBy: Sender.jeune),
            // Just to make sure production code properly retrieve the latest date of messages read by conseiller.
            // CVM should normally not send more than one message with readByConseiller to true.
            mockCvmTextMessage(date: DateTime(2022, 1, 2), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 3), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 4), sentBy: Sender.jeune),
          ]),
        );

        test('should update chat status properly', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectChangingStatesThroughOrder([
            _shouldHaveChatStatus(hasUnreadMessages: false, lastConseillerReading: DateTime(2022, 1, 3)),
          ]);
        });
      });

      group('when a message is read from conseiller but no jeune last reading', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022, 1, 1), sentBy: Sender.jeune),
            // Just to make sure production code properly retrieve the latest date of messages read by conseiller.
            // CVM should normally not send more than one message with readByConseiller to true.
            mockCvmTextMessage(date: DateTime(2022, 1, 2), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 3), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 4), sentBy: Sender.jeune),
            mockCvmTextMessage(date: DateTime(2022, 1, 5), sentBy: Sender.conseiller, readByJeune: false),
          ]),
        );

        test('should update chat status properly', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectChangingStatesThroughOrder([
            _shouldHaveChatStatus(hasUnreadMessages: true, lastConseillerReading: DateTime(2022, 1, 3)),
          ]);
        });
      });

      group('when a message is read from conseiller and last reading on old message', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022, 1, 1), sentBy: Sender.jeune),
            // Just to make sure production code properly retrieve the latest date of messages read by conseiller.
            // CVM should normally not send more than one message with readByConseiller to true.
            mockCvmTextMessage(date: DateTime(2022, 1, 2), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 3), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 4), sentBy: Sender.jeune),
            mockCvmTextMessage(date: DateTime(2022, 1, 5), sentBy: Sender.conseiller, readByJeune: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 6), sentBy: Sender.conseiller, readByJeune: false),
          ]),
        );

        test('should update chat status properly', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectChangingStatesThroughOrder([
            _shouldHaveChatStatus(hasUnreadMessages: true, lastConseillerReading: DateTime(2022, 1, 3)),
          ]);
        });
      });

      group('when a message is read from conseiller and last reading on latest message', () {
        sut.whenDispatchingAction(
          () => CvmSuccessAction([
            mockCvmTextMessage(date: DateTime(2022, 1, 1), sentBy: Sender.jeune),
            // Just to make sure production code properly retrieve the latest date of messages read by conseiller.
            // CVM should normally not send more than one message with readByConseiller to true.
            mockCvmTextMessage(date: DateTime(2022, 1, 2), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 3), sentBy: Sender.jeune, readByConseiller: true),
            mockCvmTextMessage(date: DateTime(2022, 1, 4), sentBy: Sender.jeune),
            mockCvmTextMessage(date: DateTime(2022, 1, 5), sentBy: Sender.conseiller, readByJeune: false),
            mockCvmTextMessage(date: DateTime(2022, 1, 6), sentBy: Sender.conseiller, readByJeune: true),
          ]),
        );

        test('should update chat status properly', () {
          sut.givenStore = givenState() //
              .loggedInPoleEmploiUser()
              .store();

          sut.thenExpectChangingStatesThroughOrder([
            _shouldHaveChatStatus(hasUnreadMessages: false, lastConseillerReading: DateTime(2022, 1, 3)),
          ]);
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

Matcher _shouldHaveChatStatus({required bool hasUnreadMessages, required DateTime lastConseillerReading}) {
  return StateIs<ChatStatusSuccessState>(
    (state) => state.chatStatusState,
    (state) => expect(
      state,
      ChatStatusSuccessState(hasUnreadMessages: hasUnreadMessages, lastConseillerReading: lastConseillerReading),
    ),
  );
}
