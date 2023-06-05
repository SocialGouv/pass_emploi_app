import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi_details_page_view_model.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  //TODO: manque un test sur les properties. Reviewer, je m'en occupe TKT :p

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
      expect(viewModel.displayState, DisplayState.LOADING);
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
      expect(viewModel.displayState, DisplayState.CONTENT);
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
      expect(viewModel.displayState, DisplayState.FAILURE);
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
