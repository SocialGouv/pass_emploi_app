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

    test('should be invalid if duplicated user action has empty date', () {
      // Given
      final duplicatedAction = DuplicatedUserAction(
        id: 'test-id',
        dateSource: DateNotInitialized(),
        description: 'test description',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [duplicatedAction],
      );

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be valid if duplicated user action has valid date and description', () {
      // Given
      final duplicatedAction = DuplicatedUserAction(
        id: 'test-id',
        dateSource: DateFromSuggestion(DateTime.now(), "test"),
        description: 'test description',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [duplicatedAction],
      );

      // When & Then
      expect(viewModel.isValid, true);
    });

    test('should be valid if duplicated user action has date from picker and description', () {
      // Given
      final duplicatedAction = DuplicatedUserAction(
        id: 'test-id',
        dateSource: DateFromPicker(DateTime.now()),
        description: 'test description',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [duplicatedAction],
      );

      // When & Then
      expect(viewModel.isValid, true);
    });

    test('should be invalid if duplicated user action has empty description', () {
      // Given
      final duplicatedAction = DuplicatedUserAction(
        id: 'test-id',
        dateSource: DateFromPicker(DateTime.now()),
        description: null,
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [duplicatedAction],
      );

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be invalid if duplicated user action has empty string description', () {
      // Given
      final duplicatedAction = DuplicatedUserAction(
        id: 'test-id',
        dateSource: DateFromPicker(DateTime.now()),
        description: '',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [duplicatedAction],
      );

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be invalid if any duplicated user action is invalid', () {
      // Given
      final validAction = DuplicatedUserAction(
        id: 'valid-id',
        dateSource: DateFromPicker(DateTime.now()),
        description: 'valid description',
      );
      final invalidAction = DuplicatedUserAction(
        id: 'invalid-id',
        dateSource: DateNotInitialized(),
        description: 'invalid description',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [validAction, invalidAction],
      );

      // When & Then
      expect(viewModel.isValid, false);
    });

    test('should be valid if all duplicated user actions are valid', () {
      // Given
      final validAction1 = DuplicatedUserAction(
        id: 'valid-id-1',
        dateSource: DateFromPicker(DateTime.now()),
        description: 'valid description 1',
      );
      final validAction2 = DuplicatedUserAction(
        id: 'valid-id-2',
        dateSource: DateFromSuggestion(DateTime.now(), "test"),
        description: 'valid description 2',
      );
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: [validAction1, validAction2],
      );

      // When & Then
      expect(viewModel.isValid, true);
    });

    test('canCreateMoreDuplicatedUserActions should be true when less than 5 actions', () {
      // Given
      final viewModel = CreateUserActionStep3ViewModel();

      // When & Then
      expect(viewModel.canCreateMoreDuplicatedUserActions, true);
    });

    test('canCreateMoreDuplicatedUserActions should be false when 5 actions', () {
      // Given
      final actions = List.generate(
          5,
          (index) => DuplicatedUserAction(
                id: 'id-$index',
                dateSource: DateFromPicker(DateTime.now()),
                description: 'description $index',
              ));
      final viewModel = CreateUserActionStep3ViewModel(
        initialDuplicatedUserActions: actions,
      );

      // When & Then
      expect(viewModel.canCreateMoreDuplicatedUserActions, false);
    });
  });
}
