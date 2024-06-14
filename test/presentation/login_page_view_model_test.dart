import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/preferred_login_mode/preferred_login_mode_state.dart';
import 'package:pass_emploi_app/presentation/login_page_view_model.dart';
import 'package:pass_emploi_app/ui/drawables.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EntreePageViewModel', () {
    test('entree page view model should not display demander un compte when brand is BRSA', () {
      // Given
      final store = givenBrsaState().store();

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
      final store = givenState().loggedInUser().store();

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
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeNotInitializedState())
            .loggedInUser()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, isNull);
      });

      test('should not display preferred login mode when state is success but login mode is null', () {
        // Given
        final store =
            givenState().copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(null)).loggedInUser().store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, isNull);
      });

      test('should display pole emploi login mode', () {
        // Given
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.POLE_EMPLOI))
            .loggedInUser()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(
            viewModel.preferredLoginMode,
            PreferredLoginModeViewModel(
              title: 'France travail',
              logo: Drawables.poleEmploiLogo,
            ));
      });

      test('should display milo login mode', () {
        // Given
        final store = givenState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedInUser()
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

      test('should not display preferred login mode when brand is brsa', () {
        // Given
        final store = givenBrsaState()
            .copyWith(preferredLoginModeState: PreferredLoginModeSuccessState(LoginMode.MILO))
            .loggedInUser()
            .store();

        // When
        final viewModel = LoginPageViewModel.create(store);

        // Then
        expect(viewModel.preferredLoginMode, null);
      });
    });
  });
}
