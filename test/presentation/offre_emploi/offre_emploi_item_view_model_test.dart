import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/image_path.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';

import '../../doubles/fixtures.dart';

void main() {
  test('when contract type is "MIS" should display explicitly that we are talking about interim contract type', () {
    // Given
    final offre = mockOffreEmploi(contractType: 'MIS');

    // When
    final viewModel = OffreEmploiItemViewModel.create(offre);

    // Then
    expect(viewModel.contractType, 'Intérim');
  });

  group("origin", () {
    test('when origin is France Travail', () {
      // Given
      final offre = mockOffreEmploi(origin: FranceTravailOrigin());

      // When
      final viewModel = OffreEmploiItemViewModel.create(offre);

      // Then
      expect(
        viewModel.originViewModel,
        OffreEmploiOriginViewModel(
          "France Travail",
          AssetsImagePath("assets/logo-france-travail.webp"),
        ),
      );
    });

    test('when origin is partenaire', () {
      // Given
      final offre = mockOffreEmploi(
        origin: PartenaireOrigin(
          name: "Indeed",
          logoUrl: "http://logo-indeed.jpg",
        ),
      );

      // When
      final viewModel = OffreEmploiItemViewModel.create(offre);

      // Then
      expect(
        viewModel.originViewModel,
        OffreEmploiOriginViewModel(
          "Indeed",
          NetworkImagePath("http://logo-indeed.jpg"),
        ),
      );
    });
  });
}
