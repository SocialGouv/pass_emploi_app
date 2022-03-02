import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("On chat first subscription, chat is loading then display messages", () async {
    // Given
    final factory = TestStoreFactory();
    final repository = ChatRepositoryStub();
    repository.onMessageStreamReturns([_mockMessage()]);
    factory.chatRepository = repository;
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final displayedLoading = store.onChange.any((element) => element.chatState is ChatLoadingState);
    final newState = store.onChange.firstWhere((element) => element.chatState is ChatSuccessState);

    // When
    store.dispatch(SubscribeToChatAction());

    // Then
    expect(await displayedLoading, true);
    expect(((await newState).chatState as ChatSuccessState).messages, [_mockMessage()]);
  });

  test("On chat other subscriptions, previous chat messages are displayed first, then new ones are displayed",
      () async {
    // Given
    final factory = TestStoreFactory();
    final repository = ChatRepositoryStub();
    repository.onMessageStreamReturns([_mockMessage('1'), _mockMessage('2')]);
    factory.chatRepository = repository;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginSuccessState(mockUser()),
        chatState: ChatSuccessState([_mockMessage('1')]),
      ),
    );
    final newState1 = store.onChange.firstWhere((e) => e.chatState is ChatSuccessState);
    final newState2 = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length > 1);

    // When
    store.dispatch(SubscribeToChatAction());

    // Then
    expect(((await newState1).chatState as ChatSuccessState).messages, [_mockMessage('1')]);
    expect(((await newState2).chatState as ChatSuccessState).messages, [_mockMessage('1'), _mockMessage('2')]);
  });

  group("On chat status subscription, conseiller info are retrieved and properly modify state", () {
    void assertState(ConseillerMessageInfo info, ChatStatusState expectedState) {
      test("$info -> $expectedState", () async {
        // Given
        final factory = TestStoreFactory();
        final repository = ChatRepositoryStub();
        repository.onChatStatusStreamReturns(info);
        factory.chatRepository = repository;
        final store = factory.initializeReduxStore(initialState: loggedInState());
        final newStateFuture = store.onChange.firstWhere((e) => e.chatStatusState is! ChatStatusNotInitializedState);

        // When
        store.dispatch(SubscribeToChatStatusAction());

        // Then
        final newState = await newStateFuture;
        expect(newState.chatStatusState, expectedState);
      });
    }

    assertState(
      ConseillerMessageInfo(null, null),
      ChatStatusState.empty(),
    );
    assertState(
      ConseillerMessageInfo(22, null),
      ChatStatusState.success(unreadMessageCount: 22, lastConseillerReading: _minDateTime),
    );
    assertState(
      ConseillerMessageInfo(null, DateTime(2022)),
      ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: DateTime(2022)),
    );
    assertState(
      ConseillerMessageInfo(22, DateTime(2022)),
      ChatStatusState.success(unreadMessageCount: 22, lastConseillerReading: DateTime(2022)),
    );
  });
}

Message _mockMessage([String id = '1']) => Message("content $id", DateTime.utc(2022, 1, 1), Sender.conseiller);
