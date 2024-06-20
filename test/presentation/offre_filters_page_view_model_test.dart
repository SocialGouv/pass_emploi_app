import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/offre_filters_page_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('create when brand is CEJ should return all solutions types', () {
    // Given
    final store = givenState(configuration(brand: Brand.cej)).store();

    // When
    final viewModel = OffreFiltersPageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.alternance, OffreType.immersion, OffreType.serviceCivique],
    );
  });

  test('create when brand is pass emploi should only return OffreEmploi and Alternance', () {
    // Given
    final store = givenState(configuration(brand: Brand.passEmploi)).store();

    // When
    final viewModel = OffreFiltersPageViewModel.create(store);

    // Then
    expect(
      viewModel.offreTypes,
      [OffreType.emploi, OffreType.immersion],
    );
  });
}
