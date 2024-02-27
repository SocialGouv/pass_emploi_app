import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/presentation/login_bottom_sheet_view_model.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('LoginBottomSheetViewModel', () {
    group('loginButtons', () {
      test("view model when brand is BRSA and flavor is prod should only display pole emploi button", () {
        // Given
        final store = givenState(configuration(flavor: Flavor.PROD, brand: Brand.brsa))
            .copyWith(loginState: UserNotLoggedInState())
            .store();

        // When
        final viewModel = LoginBottomSheetViewModel.create(store);

        // Then
        expect(viewModel.loginButtons, [
          LoginButtonViewModelPoleEmploi(store),
        ]);
      });

      test("view model when brand is BRSA and flavor is staging should display pole emploi and pass emploi buttons",
          () {
        // Given
        final store = givenState(configuration(flavor: Flavor.STAGING, brand: Brand.brsa))
            .copyWith(loginState: UserNotLoggedInState())
            .store();

        // When
        final viewModel = LoginBottomSheetViewModel.create(store);

        // Then
        expect(viewModel.loginButtons, [
          LoginButtonViewModelPoleEmploi(store),
          LoginButtonViewModelPassEmploi(store),
        ]);
      });

      test(
          "view model when flavor is staging and brand CEJ should show 3 buttons : mission locale, pole emploi and pass emploi",
          () {
        // Given
        final store = givenState(configuration(flavor: Flavor.STAGING, brand: Brand.cej))
            .copyWith(loginState: UserNotLoggedInState())
            .store();

        // When
        final viewModel = LoginBottomSheetViewModel.create(store);

        // Then
        expect(viewModel.loginButtons, [
          LoginButtonViewModelPoleEmploi(store),
          LoginButtonViewModelMissionLocale(store),
          LoginButtonViewModelPassEmploi(store),
        ]);
      });

      test("view model when flavor is prod and brand CEJ should show 2 buttons : mission locale and pole emploi", () {
        // Given
        final store = givenState(configuration(flavor: Flavor.PROD, brand: Brand.cej))
            .copyWith(loginState: UserNotLoggedInState())
            .store();

        // When
        final viewModel = LoginBottomSheetViewModel.create(store);

        // Then
        expect(viewModel.loginButtons, [
          LoginButtonViewModelPoleEmploi(store),
          LoginButtonViewModelMissionLocale(store),
        ]);
      });

      test('View model triggers RequestLoginAction with PASS_EMPLOI mode when pass emploi login is performed', () {
        // Given
        final store = StoreSpy();
        final viewModel = LoginBottomSheetViewModel.create(store);

        // When
        viewModel.loginButtons[2].action();

        // Then
        expect(store.dispatchedAction, isA<RequestLoginAction>());
        expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.PASS_EMPLOI);
      });

      test('View model triggers RequestLoginAction with POLE_EMPLOI mode when Pole Emploi login is performed', () {
        // Given
        final store = StoreSpy();
        final viewModel = LoginBottomSheetViewModel.create(store);

        // When
        viewModel.loginButtons[0].action();

        // Then
        expect(store.dispatchedAction, isA<RequestLoginAction>());
        expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.POLE_EMPLOI);
      });

      test('View model triggers RequestLoginAction with SIMILO mode when Mission Locale login is performed', () {
        // Given
        final store = StoreSpy();
        final viewModel = LoginBottomSheetViewModel.create(store);

        // When
        viewModel.loginButtons[1].action();

        // Then
        expect(store.dispatchedAction, isA<RequestLoginAction>());
        expect((store.dispatchedAction as RequestLoginAction).mode, RequestLoginMode.SIMILO);
      });
    });
  });
}
