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
    final detailedOffer = mockedDetailedOffer();
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        detailedOfferState: DetailedOfferState.success(detailedOffer),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_DETAILS);
    expect(viewModel.id, detailedOffer.id);
    expect(viewModel.title, detailedOffer.title);
    expect(viewModel.companyName, detailedOffer.companyName);
    expect(viewModel.contractType, detailedOffer.contractType);
    expect(viewModel.duration, detailedOffer.duration);
    expect(viewModel.location, detailedOffer.location);
    expect(viewModel.salary, detailedOffer.salary);
    expect(viewModel.offerDescription, detailedOffer.offerDescription);
    expect(viewModel.experience, detailedOffer.experience);
    expect(viewModel.requiredExperience, detailedOffer.requiredExperience);
    expect(viewModel.companyUrl, detailedOffer.companyUrl);
    expect(viewModel.companyAdapted, detailedOffer.companyAdapted);
    expect(viewModel.companyAccessibility, detailedOffer.companyAccessibility);
    expect(viewModel.companyDescription, detailedOffer.companyDescription);
    // DateTime(2021, 11, 22, 14, 47, 29)
    expect(viewModel.lastUpdate, "22 novembre 2021");
    expect(viewModel.skills, detailedOffer.skills);
    expect(viewModel.softSkills, detailedOffer.softSkills);
    expect(viewModel.educations, detailedOffer.educations);
    expect(viewModel.languages, detailedOffer.languages);
    expect(viewModel.driverLicences, detailedOffer.driverLicences);
  });
}
