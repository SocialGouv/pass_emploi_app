import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/recherche/recherche_home_page_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when accompagnement is CEJ should return all solutions types', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.cej).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.alternance, OffreType.immersion, OffreType.serviceCivique],
    );
  });

  test('create when accompagnement is AIJ should return all solutions types', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.aij).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.alternance, OffreType.immersion, OffreType.serviceCivique],
    );
  });

  test('create when accompagnement is Avenir Pro should return all solutions types', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.avenirPro).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.alternance, OffreType.immersion, OffreType.serviceCivique],
    );
  });

  test('create when accompagnement is RSA should only return OffreEmploi and Alternance', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.rsaFranceTravail).store();

    // When
    final viewModel = RechercheHomePageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.immersion],
    );
  });
}
