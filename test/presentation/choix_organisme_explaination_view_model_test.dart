import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/presentation/choix_organisme_explaination_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/spies.dart';

void main() {
  test("create should set proper text when user chose Pole Emploi", () {
    // Given
    final state = AppState.initialState();
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChoixOrganismeExplainationViewModel.create(store, isPoleEmploi: true);

    // Then
    expect(viewModel.explainationText,
        "Prenez rendez-vous avec votre conseiller France Travail qui procédera à la création de votre compte.");
  });

  test("create should set proper text when user chose Mission Locale", () {
    // Given
    final state = AppState.initialState();
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChoixOrganismeExplainationViewModel.create(store, isPoleEmploi: false);

    // Then
    expect(viewModel.explainationText,
        "Prenez rendez-vous avec votre conseiller Mission Locale qui procédera à la création de votre compte.");
  });

  test('view model triggers RequestLoginAction with POLE_EMPLOI mode when Pole Emploi login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = ChoixOrganismeExplainationViewModel.create(store, isPoleEmploi: true);

    // When
    viewModel.loginAction();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.POLE_EMPLOI);
  });

  test('view model triggers RequestLoginAction with SIMILO mode when Mission Locale login is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = ChoixOrganismeExplainationViewModel.create(store, isPoleEmploi: false);

    // When
    viewModel.loginAction();

    // Then
    expect(store.dispatchedAction, isA<RequestLoginAction>());
    expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.SIMILO);
  });
}
