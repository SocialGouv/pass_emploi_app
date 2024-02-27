import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test('View model displays loading when login state is loading', () {
    final store = givenState().copyWith(loginState: LoginLoadingState()).store();

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.withLoading, isTrue);
    expect(viewModel.withWrongDeviceClockMessage, isFalse);
    expect(viewModel.technicalErrorMessage, isNull);
  });

  test('View model displays error message when login state is generic failure', () {
    final store = givenState().copyWith(loginState: LoginGenericFailureState('error-message')).store();

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withWrongDeviceClockMessage, isFalse);
    expect(viewModel.technicalErrorMessage, 'error-message');
  });

  test('View model displays specific message when login state is wrong device clock failure', () {
    final store = givenState().copyWith(loginState: LoginWrongDeviceClockState()).store();

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withWrongDeviceClockMessage, isTrue);
    expect(viewModel.technicalErrorMessage, isNull);
  });

  test('View model displays content when login state is not logged in', () {
    final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withWrongDeviceClockMessage, isFalse);
    expect(viewModel.technicalErrorMessage, isNull);
  });

  test('View model displays content when login state is logged in', () {
    final store = givenState().loggedInUser().store();

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withWrongDeviceClockMessage, isFalse);
    expect(viewModel.technicalErrorMessage, isNull);
  });

  test("view model when brand is BRSA should not show ask account button", () {
    // Given
    final store = givenBrsaState().copyWith(loginState: UserNotLoggedInState()).store();

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.withAskAccountButton, false);
  });

  test("view model when brand is CEJ should show ask account button", () {
    // Given
    final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.withAskAccountButton, true);
  });

  test("view model when brand is BRSA should have corresponding suivi text", () {
    // Given
    final store = givenBrsaState().copyWith(loginState: UserNotLoggedInState()).store();

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.suiviText, "Je suis suivi par un conseiller :");
  });

  test("view model when brand is CEJ should have corresponding suivi text", () {
    // Given
    final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.suiviText, "Dans le cadre de mon Contrat d'Engagement Jeune, je suis suivi par un conseiller :");
  });
}
