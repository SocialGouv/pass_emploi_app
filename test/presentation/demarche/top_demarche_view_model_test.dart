import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/demarche/top_demarche_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('topDemarchesViewModel', () {
    test('when top demarche state is success should display demarche list', () {
      // Given
      final demarche = mockDemarcheDuReferentiel('id');
      final store = givenState().loggedInUser().withTopDemarcheSuccessState(demarches: [demarche]).store();

      // When
      final viewModel = TopDemarchePageViewModel.create(store);

      // Then
      expect(viewModel.demarches.length, 1);
      expect((viewModel.demarches.first).demarcheId, "id");
    });

    test('when top demarche state is not success should display empty list', () {
      // Given
      final store = givenState().loggedInUser().store();

      // When
      final viewModel = TopDemarchePageViewModel.create(store);

      // Then
      expect(viewModel.demarches.length, 0);
    });
  });
}
