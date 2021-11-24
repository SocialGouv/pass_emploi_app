import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test("getDetails when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        detailedOfferState: DetailedOfferState.loading(),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_LOADER);
  });

  test("getDetails when state is failure should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        detailedOfferState: DetailedOfferState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("getDetails when state is success should set display state properly and convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        detailedOfferState: DetailedOfferState.success(mockedDetailedOffer()),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_DETAILS);
    expect(viewModel.detailedOffer, mockedDetailedOffer());
  });
}
