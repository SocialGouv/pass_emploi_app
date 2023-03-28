import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/presentation/immersion_contact_form_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('test should create a form with user email, first name and last name', () {
    // Given
    final store = givenState().loggedInMiloUser().store();

    // When
    final viewModel = ImmersionContactFormViewModel.create(store);

    // Then
    expect(viewModel.userEmailInitialValue, "first.last@milo.fr");
    expect(viewModel.userFirstNameInitialValue, "F");
    expect(viewModel.userLastNameInitialValue, "L");
  });

  test('should send form', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withImmersionDetailsSuccess(immersionDetails: mockImmersionDetails())
        .spyStore();
    final viewModel = ImmersionContactFormViewModel.create(store);

    // When
    viewModel.onFormSubmitted(mockImmersionContactUserInput());

    // Then
    final action = store.dispatchedAction as ContactImmersionRequestAction?;
    expect(action, isNotNull);
    expect(action!.request.immersionDetails, mockImmersionDetails());
    expect(action.request.userInput, mockImmersionContactUserInput());
  });
}
