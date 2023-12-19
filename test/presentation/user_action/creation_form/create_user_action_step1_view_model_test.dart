import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';

void main() {
  group('CreateUserActionStep1ViewModel', () {
    test('initial viewModel should be invalid', () {
      // Given
      final viewModel = CreateUserActionStep1ViewModel();

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be valid when category is not null', () {
      // Given
      final viewModel = CreateUserActionStep1ViewModel(actionCategory: UserActionReferentielType.cultureSportLoisirs);

      // When & Then
      expect(viewModel.isValid, true);
    });
  });
}
