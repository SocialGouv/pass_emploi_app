import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('should have zero item', () {
    // Given
    final store = givenState().loggedInUser().store();

    // When
    final viewModel = AccueilViewModel.create(store);

    // Then
    expect(viewModel.items, []);
  });
}
