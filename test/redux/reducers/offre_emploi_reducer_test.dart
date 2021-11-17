import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';

import '../../models/offre_emploi_test.dart';

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
    final offres = offreEmploiData();
    assertState(OffreEmploiSearchSuccessAction(offres: offres, page: 1), OffreEmploiSearchState.success(offres, 1));
  });
}
