import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';

main() {
  group("reducer with chat actions modifying chat state", () {
    void assertState(dynamic action, ChatState expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.chatState, expectedState);
      });
    }

    assertState(ChatLoadingAction(), ChatState.loading());
    assertState(ChatFailureAction(), ChatState.failure());
    final message = Message("content", DateTime(2022), Sender.jeune);
    assertState(ChatSuccessAction([message]), ChatState.success([message]));
  });

  group("reducer with chat actions modifying chat status state", () {
    void assertState(dynamic action, ChatStatusState expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.chatStatusState, expectedState);
      });
    }

    assertState(
      ChatConseillerMessageAction(null, null),
      ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: _minDateTime),
    );
    assertState(
      ChatConseillerMessageAction(22, null),
      ChatStatusState.success(unreadMessageCount: 22, lastConseillerReading: _minDateTime),
    );
    assertState(
      ChatConseillerMessageAction(null, DateTime(2022)),
      ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: DateTime(2022)),
    );
    assertState(
      ChatConseillerMessageAction(22, DateTime(2022)),
      ChatStatusState.success(unreadMessageCount: 22, lastConseillerReading: DateTime(2022)),
    );
  });
}

final DateTime _minDateTime = DateTime.fromMicrosecondsSinceEpoch(0);
