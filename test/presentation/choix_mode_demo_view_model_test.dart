import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/choix_mode_demo_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('ChoixModeDemoViewModel', () {
    test('should not display milo mode button when brand is BRSA', () {
      // Given
      final store = givenBrsaState().store();

      // When
      final viewModel = ChoixModeDemoViewModel.create(store);

      // Then
      expect(viewModel.demoLoginModes, [LoginMode.DEMO_PE]);
      expect(viewModel.shouldDisplayMiloMode, false);
    });

    test('should display milo mode button when brand is CEJ', () {
      // Given
      final store = givenState(configuration(brand: Brand.cej)).store();

      // When
      final viewModel = ChoixModeDemoViewModel.create(store);

      // Then
      expect(viewModel.demoLoginModes, [LoginMode.DEMO_PE, LoginMode.DEMO_MILO]);
      expect(viewModel.shouldDisplayMiloMode, true);
    });
  });
}
