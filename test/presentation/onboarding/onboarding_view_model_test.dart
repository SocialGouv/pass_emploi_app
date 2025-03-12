import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/onboarding/onboarding_view_model.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('OnboardingViewModel', () {
    group('when onboarding source is monSuivi', () {
      test("create should properly display infos for milo user", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.monSuivi);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_mon_suivi.webp",
            title: "Pas à pas, trouvez un emploi stable",
            body:
                "Mon suivi vous permet de créer et visualiser les différentes actions ou rendez-vous à réaliser. Votre conseiller peut aussi ajouter des actions dans cette section !",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });

      test("create should properly display infos for pe user", () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.monSuivi);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_mon_suivi.webp",
            title: "Pas à pas, trouvez un emploi stable",
            body:
                "Mon suivi vous permet de créer et visualiser les différentes démarches ou rendez-vous à réaliser. Votre conseiller peut aussi ajouter des démarches dans cette section !",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });
    });

    group('when onboarding source is chat', () {
      test("create should properly display infos", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.chat);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_chat.webp",
            title: "Gardez contact avec votre conseiller à tout moment",
            body:
                "Échangez sur la messagerie instantanée avec votre conseiller pour construire votre projet, partager des offres, vous inscrire à des évènements, etc.",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });
    });

    group('when onboarding source is reherche', () {
      test("create should properly display infos for milo user", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.reherche);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_recherche.webp",
            title: "Trouvez des offres qui vous intéressent",
            body:
                "L’espace recherche vous permet de retrouver les offres d’emploi d’alternance, d’immersion et de service civique, et de les ajouter à vos offres enregistrées.",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });

      test("create should properly display infos for pe user", () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.reherche);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_recherche.webp",
            title: "Trouvez des offres qui vous intéressent",
            body:
                "L’espace recherche vous permet de retrouver les offres d’emploi qui vous intéressent et de les ajouter à vos offres enregistrées.",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });
    });

    group('when onboarding source is evenements', () {
      test("create should properly display infos", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.evenements);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "C'est compris",
            illustration: "assets/onboarding/illustration_onboarding_evenements.webp",
            title: "Participez à des événements en lien avec votre recherche",
            body:
                "Découvrez les événements à ne pas manquer en lien avec votre recherche et inscrivez-vous pour y participer.",
            onPrimaryButton: () {},
            canClose: false,
          ),
        );
      });
    });

    group('when onboarding is offre enregistré', () {
      test("create should properly display infos", () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = OnboardingViewModel.create(store, OnboardingSource.offresEnregistrees);

        // Then
        expect(
          viewModel,
          OnboardingViewModel(
            primaryButtonText: "Découvrir",
            illustration: "assets/onboarding/illustration_onboarding_offre_enregistree.webp",
            title: "Nouveau !",
            body: "Retrouvez maintenant vos favoris dans l’onglet “Suivi des offres”",
            onPrimaryButton: () {},
            canClose: true,
          ),
        );
      });
    });
  });
}
