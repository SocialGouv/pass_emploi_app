import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_action_form_view_models/create_user_action_form_view_model.dart';

void main() {
  group("CreateUserActionStep3ViewModel", () {
    test('initial state should be invalid', () {
      // Given
      final state = CreateUserActionStep3ViewModel();

      // When & Then
      expect(state.isValid, false);
    });

    test('should be invalid if date is empty', () {
      // Given
      final state = CreateUserActionStep3ViewModel(date: CreateActionDateNotInitialized());

      // When & Then
      expect(state.isValid, false);
    });

    test('should be valid if date is from suggestions', () {
      // Given
      final state = CreateUserActionStep3ViewModel(date: CreateActionDateFromSuggestions(DateTime.now(), "test"));

      // When & Then
      expect(state.isValid, true);
    });

    test('should be valid if date is from input', () {
      // Given
      final state = CreateUserActionStep3ViewModel(date: CreateActionDateFromUserInput(DateTime.now()));

      // When & Then
      expect(state.isValid, true);
    });
  });
}
