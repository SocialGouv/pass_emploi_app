import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/partage_offre_page_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {

  test('should display title on success', () {
    // Given
    final store = givenState().offreEmploiDetailsSuccess().store();

    // When
    final viewModel = PartageOffrePageViewModel.create(store);

    // Then
    expect(viewModel.offreTitle, "Technicien / Technicienne d'installation de réseaux câblés  (H/F)");
  });

  test('should throw error on failure', () {
    final store = givenState().store();
    expect(() => PartageOffrePageViewModel.create(store), throwsA(isA<Exception>()));
  });
}