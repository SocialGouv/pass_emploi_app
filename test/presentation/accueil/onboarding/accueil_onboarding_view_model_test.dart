import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/accueil/onboarding/accueil_onboarding_view_model.dart';

import '../../../dsl/app_state_dsl.dart';

void main() {
  group('AccueilOnboardingViewModel', () {
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
              ),
            ),
          )
          .store();

      // When
      final viewModel = AccueilOnboardingViewModel.create(store);

      // Then
      expect(viewModel.userName, "Kenji ");
    });

    group('body1', () {
      test("should display milo message", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = AccueilOnboardingViewModel.create(store);

        // Then
        expect(viewModel.body1,
            "Retrouvez sur la page d’accueil un condensé des différentes informations utiles à votre recherche : actions à réaliser, offres enregistrées, prochains rendez-vous, etc.");
      });

      test("should display pole emploi message", () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().store();

        // When
        final viewModel = AccueilOnboardingViewModel.create(store);

        // Then
        expect(viewModel.body1,
            "Retrouvez sur la page d’accueil un condensé des différentes informations utiles à votre recherche : démarches à réaliser, offres enregistrées, prochains rendez-vous, etc.");
      });
    });
  });
}
