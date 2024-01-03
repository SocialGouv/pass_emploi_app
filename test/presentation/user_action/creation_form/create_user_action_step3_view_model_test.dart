import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';

void main() {
  group("CreateUserActionStep3ViewModel", () {
    test('initial viewModel should be invalid', () {
      // Given
      final viewModel = CreateUserActionStep3ViewModel();

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be invalid if date is empty', () {
      // Given
      final viewModel = CreateUserActionStep3ViewModel(dateSource: DateNotInitialized());

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be valid if date is from suggestions', () {
      // Given
      final viewModel = CreateUserActionStep3ViewModel(dateSource: DateFromSuggestion(DateTime.now(), "test"));

      // When & Then
      expect(viewModel.isValid, true);
    });

    test('should be valid if date is from input', () {
      // Given
      final viewModel = CreateUserActionStep3ViewModel(dateSource: DateFromPicker(DateTime.now()));

      // When & Then
      expect(viewModel.isValid, true);
    });
  });
}
