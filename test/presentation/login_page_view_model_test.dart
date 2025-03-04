import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/login_page_view_model.dart';
import 'package:pass_emploi_app/ui/drawables.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EntreePageViewModel', () {
    test('entree page view model should not display demander un compte when brand is pass emploi', () {
      // Given
      final store = givenPassEmploiState().store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, false);
    });

    test('entree page view model should display demander un compte when brand is CEJ', () {
      // Given
      final store = givenState().store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, true);
    });

    test('View model displays loading when login state is loading', () {
      // Given
      final store = givenState().copyWith(loginState: LoginLoadingState()).store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withLoading, isTrue);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays error message when login state is generic failure', () {
      // Given
      final store = givenState().copyWith(loginState: LoginGenericFailureState('error-message')).store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, 'error-message');
    });

    test('View model displays specific message when login state is wrong device clock failure', () {
      // Given
      final store = givenState().copyWith(loginState: LoginWrongDeviceClockState()).store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isTrue);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays content when login state is not logged in', () {
      // Given
      final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays content when login state is logged in', () {
      // Given
      final store = givenState().loggedIn().store();

      // When
      final viewModel = LoginPageViewModel.create(store);

      // Then
      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    group('preferredLoginMode', () {
      test('should not display preferred login mode when state is not success', () {
        // Given
        final store =
            givenState().copyWith(preferredLoginModeState: PreferredLoginModeNotInitializedState()).loggedIn().store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, isNull);
      });

      test('should not display preferred login mode when state is success but login mode is null', () {
        // Given
        final store =
            givenState().copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(null)).loggedIn().store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, isNull);
      });

      test('should display pole emploi login mode', () {
        // Given
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.POLE_EMPLOI))
            .loggedIn()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(
            viewModel.preferredLoginMode,
            PreferredLoginModeViewModel(
              title: 'France travail',
              logo: Drawables.franceTravailLogo,
            ));
      });

      test('should display milo login mode', () {
        // Given
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedIn()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(
            viewModel.preferredLoginMode,
            PreferredLoginModeViewModel(
              title: 'Mission Locale',
              logo: Drawables.missionLocaleLogo,
            ));
      });

      test('should not display preferred login mode when brand is pass emploi', () {
        // Given
        final store = givenPassEmploiState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedIn()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, null);
      });
    });

    group('accessibility level', () {
      test('should display accessibility partially conform when brand is cej', () {
        // Given
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedIn()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.accessibilityLevelLabel, "Accessibilité : partiellement conforme");
      });

      test('should display accessibility not conform when brand is pass emploi', () {
        // Given
        final store = givenPassEmploiState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedIn()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.accessibilityLevelLabel, "Accessibilité : non conforme");
      });
    });
  });
}
