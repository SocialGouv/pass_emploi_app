import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_action_form_view_models/create_user_action_form_view_model.dart';

void main() {
  group('CreateUserActionStep1ViewModel', () {
    test('initial state should be invalid', () {
      // Given
      final state = CreateUserActionStep1ViewModel();

      // When & Then
      expect(state.isValid, false);
    });

    test('should be valid when category is not null', () {
      // Given
      final state = CreateUserActionStep1ViewModel(actionCategory: UserActionReferentielType.cultureSportLoisirs);

      // When & Then
      expect(state.isValid, true);
    });
  });
}
