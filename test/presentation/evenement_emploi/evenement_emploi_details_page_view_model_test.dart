import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_details_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("view model", () {
    // Given
    final store = givenState()
        .loggedInUser() //
        .copyWith(evenementEmploiDetailsState: EvenementEmploiDetailsSuccessState(mockEvenementEmploiDetails()))
        .store();

    // When
    final viewModel = EvenementEmploiDetailsPageViewModel.create(store);

    // Then
    expect(
      viewModel,
      EvenementEmploiDetailsPageViewModel(
        displayState: DisplayState.contenu,
        tag: "Réunion d'information",
        titre: "Devenir conseiller à Pôle emploi",
        date: "15 juin 2023",
        heure: "12h - 15h",
        lieu: "95120 - Ermont",
        description: "Information collective pour découvrir les métiers de pôle emploi en vu d'un recrutement...",
        url: "https://mesevenementsemploi-t.pe-qvr.fr/mes-evenements-emploi/mes-evenements-emploi/evenement/106757",
        retry: (id) => {},
      ),
    );
  });

  group('Display State', () {
    test('when state is loading', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(evenementEmploiDetailsState: EvenementEmploiDetailsLoadingState())
          .store();

      // When
      final viewModel = EvenementEmploiDetailsPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test('when state is success', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(evenementEmploiDetailsState: EvenementEmploiDetailsSuccessState(mockEvenementEmploiDetails()))
          .store();

      // When
      final viewModel = EvenementEmploiDetailsPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test('when state is failure', () {
      // Given
      final store = givenState()
          .loggedInUser() //
          .copyWith(evenementEmploiDetailsState: EvenementEmploiDetailsFailureState())
          .store();

      // When
      final viewModel = EvenementEmploiDetailsPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });
  });

  test('onRetry', () {
    // Given
    final store = StoreSpy();
    final viewModel = EvenementEmploiDetailsPageViewModel.create(store);

    // When
    viewModel.retry("id");

    // Then
    expect(store.dispatchedAction is EvenementEmploiDetailsRequestAction, isTrue);
    expect((store.dispatchedAction as EvenementEmploiDetailsRequestAction).eventId, "id");
  });
}
