import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_event_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('should display state', () {
    void assertDisplayState(ChatPartageState state, DisplayState expected) {
      test('when $expected', () {
        // Given
        final store = givenState().copyWith(chatPartageState: state).store();

        // When
        final viewModel = ChatPartageEventViewModel.create(store);

        // Then
        expect(viewModel.displayState, expected);
      });
    }

    assertDisplayState(ChatPartageNotInitializedState(), DisplayState.EMPTY);
    assertDisplayState(ChatPartageLoadingState(), DisplayState.LOADING);
    assertDisplayState(ChatPartageSuccessState(), DisplayState.CONTENT);
    assertDisplayState(ChatPartageFailureState(), DisplayState.FAILURE);
  });
}
