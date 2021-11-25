import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

import '../../doubles/fixtures.dart';

main() {
  group("reducer with offre emploi actions modifying offre emploi search state", () {
    void assertState(dynamic action, OffreEmploiSearchState expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.offreEmploiSearchState, expectedState);
      });
    }

    assertState(OffreEmploiSearchLoadingAction(), OffreEmploiSearchState.loading());
    assertState(OffreEmploiSearchFailureAction(), OffreEmploiSearchState.failure());
    assertState(
      OffreEmploiSearchSuccessAction(offres: [mockOffreEmploi()], page: 1, isMoreDataAvailable: true),
      OffreEmploiSearchState.success(),
    );
  });
}
