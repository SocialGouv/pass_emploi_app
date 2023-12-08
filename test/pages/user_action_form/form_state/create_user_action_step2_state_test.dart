import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/pages/user_action_form/form_state/create_user_action_form_state.dart';

void main() {
  group('CreateUserActionStep2State', () {
    test('initial state should be invalid', () {
      // Given
      final state = CreateUserActionStep2State();

      // When & Then
      expect(state.isValid, false);
    });

    test('should be invalid when titleSource is from suggestions', () {
      // Given
      final state = CreateUserActionStep2State(titleSource: CreateActionTitleNone());

      // When & Then
      expect(state.isValid, false);
    });
    test('should be valid when titleSource is from suggestions', () {
      // Given
      final state = CreateUserActionStep2State(titleSource: CreateActionTitleFromSuggestions(""));

      // When & Then
      expect(state.isValid, true);
    });

    test('should be invalid when titleSource is from user input and title is empty', () {
      // Given
      final state = CreateUserActionStep2State(titleSource: CreateActionTitleFromUserInput(""));

      // When & Then
      expect(state.isValid, false);
    });

    test('should be valid when titleSource is from user input and title is not empty', () {
      // Given
      final state = CreateUserActionStep2State(titleSource: CreateActionTitleFromUserInput("test"));

      // When & Then
      expect(state.isValid, true);
    });
  });
}
