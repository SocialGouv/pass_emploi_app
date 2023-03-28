import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_actions.dart';
import 'package:pass_emploi_app/features/contact_immersion/contact_immersion_state.dart';
import 'package:pass_emploi_app/presentation/immersion_contact_form_view_model.dart';
import 'package:pass_emploi_app/presentation/sending_state.dart';

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

  group("sending state", () {
    void assertFoo(SendingState state, ContactImmersionState bbb) {
      test("should be $state when state is $bbb", () {
        final store = givenState().loggedInMiloUser().copyWith(contactImmersionState: bbb).store();
        final viewModel = ImmersionContactFormViewModel.create(store);
        expect(viewModel.sendingState, state);
      });
    }

    assertFoo(SendingState.none, ContactImmersionNotInitializedState());
    assertFoo(SendingState.loading, ContactImmersionLoadingState());
    assertFoo(SendingState.success, ContactImmersionSuccessState());
    assertFoo(SendingState.failure, ContactImmersionFailureState());
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

  test('should send reset', () {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .withImmersionDetailsSuccess(immersionDetails: mockImmersionDetails())
        .spyStore();
    final viewModel = ImmersionContactFormViewModel.create(store);

    // When
    viewModel.resetSendingState();

    // Then
    expect(store.dispatchedAction, isA<ContactImmersionResetAction>());
  });
}
