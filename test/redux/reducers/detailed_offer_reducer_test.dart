import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../../doubles/fixtures.dart';

main() {
  group("reducer with detailed offer actions modifying detailed offer state", () {
    void assertState(dynamic action, State<OffreEmploiDetails> expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.offreEmploiDetailsState, expectedState);
      });
    }

    assertState(OffreEmploiDetailsLoadingAction(), State<OffreEmploiDetails>.loading());
    assertState(OffreEmploiDetailsFailureAction(), State<OffreEmploiDetails>.failure());
    final offre = mockOffreEmploiDetails();
    assertState(OffreEmploiDetailsSuccessAction(offre), State<OffreEmploiDetails>.success(offre));
  });
}
