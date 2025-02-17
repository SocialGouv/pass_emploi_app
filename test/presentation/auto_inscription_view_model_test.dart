import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/auto_inscription/auto_inscription_state.dart';
import 'package:pass_emploi_app/presentation/auto_inscription_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('should display state', () {
    void assertDisplayState(AutoInscriptionState state, DisplayState expected) {
      test('when $expected', () {
        // Given
        final store = givenState().copyWith(autoInscriptionState: state).store();

        // When
        final viewModel = AutoInscriptionViewModel.create(store);

        // Then
        expect(viewModel.displayState, expected);
      });
    }

    assertDisplayState(AutoInscriptionNotInitializedState(), DisplayState.LOADING);
    assertDisplayState(AutoInscriptionLoadingState(), DisplayState.LOADING);
    assertDisplayState(AutoInscriptionFailureState(error: AutoInscriptionGenericError()), DisplayState.FAILURE);
    assertDisplayState(AutoInscriptionSuccessState(), DisplayState.CONTENT);
  });

  group('error message', () {
    void assertErrorMessage(AutoInscriptionState state, String? expected) {
      test('when $expected', () {
        // Given
        final store = givenState().copyWith(autoInscriptionState: state).store();

        // When
        final viewModel = AutoInscriptionViewModel.create(store);

        // Then
        expect(viewModel.errorMessage, expected);
      });
    }

    assertErrorMessage(
      AutoInscriptionFailureState(error: AutoInscriptionGenericError()),
      null,
    );
    assertErrorMessage(
      AutoInscriptionFailureState(error: AutoInscriptionNombrePlacesInsuffisantes()),
      "Nombre de places insuffisantes",
    );
    assertErrorMessage(
      AutoInscriptionFailureState(error: AutoInscriptionConseillerInactif()),
      "Votre conseiller est inactif",
    );
    assertErrorMessage(
      AutoInscriptionSuccessState(),
      null,
    );
  });
}
