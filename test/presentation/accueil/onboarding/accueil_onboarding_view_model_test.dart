import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/onboarding/accueil_onboarding_view_model.dart';

import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("create should properly set user info", () {
    // Given
    final store = givenState()
        .copyWith(
          loginState: LoginSuccessState(
            User(
              id: "user_id",
              firstName: "Kenji",
              lastName: "Dupont",
              loginMode: LoginMode.POLE_EMPLOI,
              email: "kenji.dupont@pe.fr",
              accompagnement: Accompagnement.cej,
            ),
          ),
        )
        .store();

    // When
    final viewModel = AccueilOnboardingViewModel.create(store);

    // Then
    expect(viewModel.userName, "Kenji ");
  });

  group('body', () {
    test("should display milo message", () {
      // Given
      final store = givenState().loggedInMiloUser().store();

      // When
      final viewModel = AccueilOnboardingViewModel.create(store);

      // Then
      expect(viewModel.body,
          "Retrouvez sur la page d’accueil un condensé des différentes informations utiles à votre recherche : actions à réaliser, offres suivies, prochains rendez-vous, etc.");
    });

    test("should display pole emploi message", () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = AccueilOnboardingViewModel.create(store);

      // Then
      expect(viewModel.body,
          "Retrouvez sur la page d’accueil un condensé des différentes informations utiles à votre recherche : démarches à réaliser, offres suivies, prochains rendez-vous, etc.");
    });
  });

  group('shouldDismiss', () {
    test("when onboarding not completed should return false", () {
      // Given
      final store = givenState() //
          .withOnboardingSuccessState(Onboarding().copyWith(showAccueilOnboarding: true))
          .store();

      // When
      final viewModel = AccueilOnboardingViewModel.create(store);

      // Then
      expect(viewModel.shouldDismiss, isFalse);
    });

    test("when onboarding completed should return true", () {
      // Given
      final store = givenState() //
          .withOnboardingSuccessState(Onboarding().copyWith(showAccueilOnboarding: false))
          .store();

      // When
      final viewModel = AccueilOnboardingViewModel.create(store);

      // Then
      expect(viewModel.shouldDismiss, isTrue);
    });
  });

  test('onOnboardingCompleted', () {
    // Given
    final store = StoreSpy();
    final viewModel = AccueilOnboardingViewModel.create(store);

    // When
    viewModel.onOnboardingCompleted();

    // Then
    expect(store.dispatchedAction, isA<OnboardingAccueilSaveAction>());
  });

  test('onRequestNotificationsPermission', () {
    // Given
    final store = StoreSpy();
    final viewModel = AccueilOnboardingViewModel.create(store);

    // When
    viewModel.onRequestNotificationsPermission();

    // Then
    expect(store.dispatchedAction, isA<OnboardingPushNotificationPermissionRequestAction>());
  });
}
