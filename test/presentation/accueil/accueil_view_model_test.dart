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
          rendezVous: "3 rendez-vous",
          actionsDemarchesEnRetard: "2 actions en retard",
          actionsDemarchesARealiser: "1 action à réaliser",
        ),
      ],
    );
  });
}
