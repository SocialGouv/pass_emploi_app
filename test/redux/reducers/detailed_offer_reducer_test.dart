import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';

import '../../models/detailed_offer_test.dart';

main() {
  group("reducer with detailed offer actions modifying detailed offer state", () {
    void assertState(dynamic action, DetailedOfferState expectedState) {
      test("$action -> $expectedState", () {
        // Given
        final initialState = AppState.initialState();
        // When
        final updatedState = reducer(initialState, action);
        // Then
        expect(updatedState.detailedOfferState, expectedState);
      });
    }

    assertState(DetailedOfferLoadingAction(), DetailedOfferState.loading());
    assertState(DetailedOfferFailureAction(), DetailedOfferState.failure());
    final offer = detailedOfferData();
    assertState(DetailedOfferSuccessAction(offer),DetailedOfferState.success(offer));
  });
}
