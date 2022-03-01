import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
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
      ChatStatusEmptyState(),
    );
    assertState(
      ConseillerMessageInfo(22, null),
      ChatStatusSuccessState(unreadMessageCount: 22, lastConseillerReading: _minDateTime),
    );
    assertState(
      ConseillerMessageInfo(null, DateTime(2022)),
      ChatStatusSuccessState(unreadMessageCount: 0, lastConseillerReading: DateTime(2022)),
    );
    assertState(
      ConseillerMessageInfo(22, DateTime(2022)),
      ChatStatusSuccessState(unreadMessageCount: 22, lastConseillerReading: DateTime(2022)),
    );
  });
}

final DateTime _minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
