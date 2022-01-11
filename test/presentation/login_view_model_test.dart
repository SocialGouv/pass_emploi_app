import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/login_view_model.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

void main() {
  test('View model displays LOADER when login state is loading', () {
    final state = AppState.initialState().copyWith(loginState: State<User>.loading());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('View model displays FAILURE when login state is failure', () {
    final state = AppState.initialState().copyWith(loginState: State<User>.failure());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('View model displays CONTENT when login state is not logged in', () {
    final state = AppState.initialState().copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test('View model displays CONTENT when login state is logged in', () {
    final store = Store<AppState>(reducer, initialState: loggedInState());

    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test('View model triggers RequestLoginAction with GENERIC mode when generic login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(Flavor.STAGING, store);

    // When
    viewModel.loginButtons[2].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.GENERIC);
  });

  test('View model triggers RequestLoginAction with SIMILO mode when generic login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    // When
    viewModel.loginButtons[1].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.POLE_EMPLOI);
  });

  test('View model triggers RequestLoginAction with SIMILO mode when generic login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    // When
    viewModel.loginButtons[0].action();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.SIMILO);
  });

  test("view model when build is staging should show 3 buttons : mission locale, pole emploi and pass emploi", () {
    // Given
    final state = AppState.initialState().copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(Flavor.STAGING, store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Je suis suivi(e) par la Mission Locale", action: () {}),
      LoginButtonViewModel(label: "Je suis suivi(e) par Pôle emploi", action: () {}),
      LoginButtonViewModel(label: "Connexion pass emploi", action: () {}),
    ]);
  });

  test("view model when build is prod should show 2 buttons : mission locale and pole emploi", () {
    // Given
    final state = AppState.initialState().copyWith(loginState: UserNotLoggedInState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = LoginViewModel.create(Flavor.PROD, store);

    // Then
    expect(viewModel.loginButtons, [
      LoginButtonViewModel(label: "Je suis suivi(e) par la Mission Locale", action: () {}),
      LoginButtonViewModel(label: "Je suis suivi(e) par Pôle emploi", action: () {}),
    ]);
  });
}
