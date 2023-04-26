import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/choix_mode_demo_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('ChoixModeDemoViewModel', () {
    test('should not display milo mode button when brand is BRSA', () {
      // Given
      final store = givenBrsaState().store();

      // When
      final viewModel = ChoixModeDemoViewModel.create(store);

      // Then
      expect(viewModel.showMiloModeButton, false);
    });

    test('should display milo mode button when brand is CEJ', () {
      // Given
      final store = givenState().store();

      // When
      final viewModel = ChoixModeDemoViewModel.create(store);

      // Then
      expect(viewModel.showMiloModeButton, true);
    });
  });
}
