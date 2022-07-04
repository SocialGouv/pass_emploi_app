import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/presentation/partage_offre_page_view_model.dart';

import '../doubles/spies.dart';
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

  test('should partager offre', () {
    // Given
    final store = givenState().offreEmploiDetailsSuccess().spyStore();
    final viewModel = PartageOffrePageViewModel.create(store);

    // When
    viewModel.onPartagerOffre("Regardes ça");

    // Then
    expect(store.dispatchedAction, isA<ChatPartagerOffreAction>());
    expect(
      (store.dispatchedAction as ChatPartagerOffreAction).offre,
      OffrePartagee(
        id: "123TZKB",
        titre: "Technicien / Technicienne d'installation de réseaux câblés  (H/F)",
        url: "https://candidat.pole-emploi.fr/offres/recherche/detail/123TZKB",
        message: "Regardes ça",
      ),
    );
  });
}
