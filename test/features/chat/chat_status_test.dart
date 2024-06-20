import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';

import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final DateTime minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);

  group('ChatStatus', () {
    final sut = StoreSut();
    final repository = ChatRepositoryStub();

    group('when subscribing to chat status', () {
      sut.whenDispatchingAction(() => SubscribeToChatStatusAction());

      test('and no unread message neither last conseiller reading', () {
        repository.onChatStatusStreamReturns(ConseillerMessageInfo(false, null));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.chatRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldBeEmpty()]);
      });

      test('and unread message but no last conseiller reading', () {
        repository.onChatStatusStreamReturns(ConseillerMessageInfo(true, null));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.chatRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _shouldBeSuccessWithValues(
            hasUnreadMessages: true,
            lastConseillerReading: minDateTime,
          )
        ]);
      });

      test('and no unread message but last conseiller reading', () {
        repository.onChatStatusStreamReturns(ConseillerMessageInfo(false, DateTime(2022)));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.chatRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _shouldBeSuccessWithValues(
            hasUnreadMessages: false,
            lastConseillerReading: DateTime(2022),
          )
        ]);
      });

      test('and both unread message and last conseiller reading', () {
        repository.onChatStatusStreamReturns(ConseillerMessageInfo(true, DateTime(2022)));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.chatRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([
          _shouldBeSuccessWithValues(
            hasUnreadMessages: true,
            lastConseillerReading: DateTime(2022),
          )
        ]);
      });
    });
  });
}

Matcher _shouldBeEmpty() => StateIs<ChatStatusEmptyState>((state) => state.chatStatusState);

Matcher _shouldBeSuccessWithValues({required bool hasUnreadMessages, required DateTime lastConseillerReading}) {
  return StateIs<ChatStatusSuccessState>(
    (state) => state.chatStatusState,
    (state) => expect(
      state,
      ChatStatusSuccessState(
        hasUnreadMessages: hasUnreadMessages,
        lastConseillerReading: lastConseillerReading,
      ),
    ),
  );
}
