import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/pages/user_action_form/form_state/create_user_action_form_state.dart';

void main() {
  group("CreateUserActionStep3State", () {
    test('initial state should be invalid', () {
      // Given
      final state = CreateUserActionStep3State();

      // When & Then
      expect(state.isValid, false);
    });

    test('should be invalid if date is empty', () {
      // Given
      final state = CreateUserActionStep3State(date: CreateActionDateNone());

      // When & Then
      expect(state.isValid, false);
    });

    test('should be valid if date is from suggestions', () {
      // Given
      final state = CreateUserActionStep3State(date: CreateActionDateFromSuggestions(DateTime.now(), "test"));

      // When & Then
      expect(state.isValid, true);
    });

    test('should be valid if date is from input', () {
      // Given
      final state = CreateUserActionStep3State(date: CreateActionDateFromUserInput(DateTime.now()));

      // When & Then
      expect(state.isValid, true);
    });
  });
}
