import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  test('View model displays LOADER when login state is loading', () {
    final state = AppState.initialState().copyWith(loginState: LoginLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('View model displays FAILURE when login state is failure', () {
    final state = AppState.initialState().copyWith(loginState: LoginFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('View model displays CONTENT when login state is not logged in', () {
    final state = AppState.initialState().copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test('View model displays CONTENT when login state is logged in', () {
    final store = Store<AppState>(reducer, initialState: loggedInState());

    final viewModel = LoginViewModel.create(store);

    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test('View model triggers RequestLoginAction with PASS_EMPLOI mode when pass emploi login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(store);

    // When
    viewModel.loginButtons[2].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.PASS_EMPLOI);
  });

  test('View model triggers RequestLoginAction with POLE_EMPLOI mode when Pole Emploi login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(store);

    // When
    viewModel.loginButtons[0].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.POLE_EMPLOI);
  });

  test('View model triggers RequestLoginAction with SIMILO mode when Mission Locale login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(store);

    // When
    viewModel.loginButtons[1].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.SIMILO);
  });

  test("view model when brand is BRSA and flavor is prod should only display pole emploi button", () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.PROD, brand: Brand.BRSA))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Pôle emploi", backgroundColor: AppColors.poleEmploi, action: () {}),
    ]);
  });

  test("view model when brand is BRSA and flavor is staging should display pole emploi and pass emploi buttons", () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.STAGING, brand: Brand.BRSA))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Pôle emploi", backgroundColor: AppColors.poleEmploi, action: () {}),
      LoginButtonViewModel(label: "pass emploi", backgroundColor: AppColors.primary, action: () {}),
    ]);
  });

  test(
      "view model when flavor is staging and brand CEJ should show 3 buttons : mission locale, pole emploi and pass emploi",
      () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.STAGING, brand: Brand.CEJ))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Pôle emploi", backgroundColor: AppColors.poleEmploi, action: () {}),
      LoginButtonViewModel(label: "Mission Locale", backgroundColor: AppColors.missionLocale, action: () {}),
      LoginButtonViewModel(label: "pass emploi", backgroundColor: AppColors.primary, action: () {}),
    ]);
  });

  test("view model when flavor is prod and brand CEJ should show 2 buttons : mission locale and pole emploi", () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.PROD, brand: Brand.CEJ))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Pôle emploi", backgroundColor: AppColors.poleEmploi, action: () {}),
      LoginButtonViewModel(label: "Mission Locale", backgroundColor: AppColors.missionLocale, action: () {}),
    ]);
  });

  test("view model when brand is BRSA should not show ask account button", () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.PROD, brand: Brand.BRSA))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.withAskAccountButton, false);
  });

  test("view model when brand is CEJ should show ask account button", () {
    // Given
    final state = AppState.initialState(configuration: configuration(flavor: Flavor.PROD, brand: Brand.CEJ))
        .copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(store);

    // Then
    expect(viewModel.withAskAccountButton, true);
  });
}
