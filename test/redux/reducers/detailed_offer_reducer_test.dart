import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';

import '../../doubles/fixtures.dart';

main() {
  group("reducer with detailed offer actions modifying detailed offer state", () {
    void assertState(dynamic action, OffreEmploiDetailsState expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.detailedOfferState, expectedState);
      });
    }

    assertState(OffreEmploiDetailsLoadingAction(), OffreEmploiDetailsState.loading());
    assertState(OffreEmploiDetailsFailureAction(), OffreEmploiDetailsState.failure());
    final offer = mockedDetailedOffer();
    assertState(OffreEmploiDetailsSuccessAction(offer), OffreEmploiDetailsState.success(offer));
  });
}
