import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/entree_page_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EntreePageViewModel', () {
    test('entree page view model should not display demander un compte when brand is BRSA', () {
      // Given
      final store = givenBrsaState().agenda().store();

      // When
      final viewModel = EntreePageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, false);
    });

    test('entree page view model should display demander un compte when brand is CEJ', () {
      // Given
      final store = givenState().agenda().store();

      // When
      final viewModel = EntreePageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, true);
    });
  });
}
