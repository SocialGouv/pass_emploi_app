import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('should have cette semaine item', () {
    // Given
    final store = givenState().loggedInMiloUser().withAccueilMiloSuccess().store();

    // When
    final viewModel = AccueilViewModel.create(store);

    // Then
    expect(
      viewModel.items,
      [
        AccueilCetteSemaineItem(
          nombreRendezVous: 3,
          nombreActionsDemarchesEnRetard: 2,
          nombreActionsDemarchesARealiser: 1,
        ),
      ],
    );
  });
}
