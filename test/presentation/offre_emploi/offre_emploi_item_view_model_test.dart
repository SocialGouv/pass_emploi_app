import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_item_view_model.dart';

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
}
