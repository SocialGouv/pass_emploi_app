import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_home_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when brand is CEJ should return all solutions types', () {
    // Given
    final store = givenState(configuration(brand: Brand.cej)).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.alternance, OffreType.immersion, OffreType.serviceCivique],
    );
  });

  test('create when brand is BRSA should only return OffreEmploi and Alternance', () {
    // Given
    final store = givenState(configuration(brand: Brand.brsa)).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.immersion],
    );
  });

  group('onboarding', () {
    test('should display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showRechercheOnboarding: true)))
          .store();

      // When
      final viewModel = RechercheHomePageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isTrue);
    });

    test('should not display onboarding', () {
      // Given
      final store = givenState()
          .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showRechercheOnboarding: false)))
          .store();

      // When
      final viewModel = RechercheHomePageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowOnboarding, isFalse);
    });
  });
}
