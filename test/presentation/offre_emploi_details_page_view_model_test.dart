import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

void main() {
  test("getDetails when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiDetailsState: OffreEmploiDetailsLoadingState(),
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
        offreEmploiDetailsState: OffreEmploiDetailsFailureState(),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_ERROR);
  });

  test("getDetails when state is success should set display state properly and convert data to view model", () {
    // Given
    final detailedOffer = mockOffreEmploiDetails();
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiDetailsState: OffreEmploiDetailsSuccessState(detailedOffer),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_DETAILS);
    expect(viewModel.id, detailedOffer.id);
    expect(viewModel.title, detailedOffer.title);
    expect(viewModel.urlRedirectPourPostulation, detailedOffer.urlRedirectPourPostulation);
    expect(viewModel.companyName, detailedOffer.companyName);
    expect(viewModel.contractType, detailedOffer.contractType);
    expect(viewModel.duration, detailedOffer.duration);
    expect(viewModel.location, detailedOffer.location);
    expect(viewModel.salary, detailedOffer.salary);
    expect(viewModel.description, detailedOffer.description);
    expect(viewModel.experience, detailedOffer.experience);
    expect(viewModel.requiredExperience, detailedOffer.requiredExperience);
    expect(viewModel.companyUrl, detailedOffer.companyUrl);
    expect(viewModel.companyAdapted, detailedOffer.companyAdapted);
    expect(viewModel.companyAccessibility, detailedOffer.companyAccessibility);
    expect(viewModel.companyDescription, detailedOffer.companyDescription);
    expect(viewModel.lastUpdate, "22 novembre 2021");
    expect(viewModel.skills, detailedOffer.skills);
    expect(viewModel.softSkills, detailedOffer.softSkills);
    expect(viewModel.educations, [EducationViewModel("Bac+5 et plus ou ??quivalents conduite projet industriel", "E")]);
    expect(viewModel.languages, detailedOffer.languages);
    expect(viewModel.driverLicences, detailedOffer.driverLicences);
  });

  test("getDetails when state is incomplete data should set display state properly and convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiDetailsState: OffreEmploiDetailsIncompleteDataState(mockOffreEmploi()),
      ),
    );

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS);
    expect(viewModel.id, "123DXPM");
    expect(viewModel.title, "Technicien / Technicienne en froid et climatisation");
    expect(viewModel.urlRedirectPourPostulation, null);
    expect(viewModel.companyName, "RH TT INTERIM");
    expect(viewModel.contractType, "MIS");
    expect(viewModel.duration, "Temps plein");
    expect(viewModel.location, "77 - LOGNES");
    expect(viewModel.salary, null);
    expect(viewModel.description, null);
    expect(viewModel.experience, null);
    expect(viewModel.requiredExperience, null);
    expect(viewModel.companyUrl, null);
    expect(viewModel.companyAdapted, null);
    expect(viewModel.companyAccessibility, null);
    expect(viewModel.companyDescription, null);
    expect(viewModel.lastUpdate, null);
    expect(viewModel.skills, null);
    expect(viewModel.softSkills, null);
    expect(viewModel.educations, null);
    expect(viewModel.languages, null);
    expect(viewModel.driverLicences, null);
  });
}
