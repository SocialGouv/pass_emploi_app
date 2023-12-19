import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';

void main() {
  group('CreateUserActionStep2ViewModel', () {
    test('initial viewModel should be invalid', () {
      // Given
      final viewModel = CreateUserActionStep2ViewModel();

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be invalid when titleSource is from suggestions', () {
      // Given
      final viewModel = CreateUserActionStep2ViewModel(titleSource: CreateActionTitleNotInitialized());

      // When & Then
      expect(viewModel.isValid, false);
    });
    test('should be valid when titleSource is from suggestions', () {
      // Given
      final viewModel = CreateUserActionStep2ViewModel(titleSource: CreateActionTitleFromSuggestions(""));

      // When & Then
      expect(viewModel.isValid, true);
    });

    test('should be invalid when titleSource is from user input and title is empty', () {
      // Given
      final viewModel = CreateUserActionStep2ViewModel(titleSource: CreateActionTitleFromUserInput(""));

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be valid when titleSource is from user input and title is not empty', () {
      // Given
      final viewModel = CreateUserActionStep2ViewModel(titleSource: CreateActionTitleFromUserInput("test"));

      // When & Then
      expect(viewModel.isValid, true);
    });
  });
}
