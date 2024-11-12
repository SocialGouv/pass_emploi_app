import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_details_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("getDetails when state is loading should set display state properly", () {
    // Given
    final store = givenState().loggedIn().offreEmploiDetailsLoading().store();

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_LOADER);
  });

  test("getDetails when state is failure should set display state properly", () {
    // Given
    final store = givenState().loggedIn().offreEmploiDetailsFailure().store();

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_ERROR);
  });

  test("getDetails when state is success should set display state properly and convert data to view model", () {
    // Given
    final detailedOffer = mockOffreEmploiDetails();
    final store = givenState()
        .loggedInPoleEmploiUser()
        .offreDateDerniereConsultation({detailedOffer.id: DateTime(2024, 1, 1)})
        .offreEmploiDetailsSuccess(offreEmploiDetails: detailedOffer)
        .store();

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, OffreEmploiDetailsPageDisplayState.SHOW_DETAILS);
    expect(viewModel.id, detailedOffer.id);
    expect(viewModel.title, detailedOffer.title);
    expect(viewModel.urlRedirectPourPostulation, detailedOffer.urlRedirectPourPostulation);
    expect(viewModel.companyName, detailedOffer.companyName);
    expect(viewModel.contractType, detailedOffer.contractType);
    expect(viewModel.dateDerniereConsultation, DateTime(2024, 1, 1));
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
    expect(viewModel.educations, [EducationViewModel("Bac+5 et plus ou équivalents conduite projet industriel", "E")]);
    expect(viewModel.languages, detailedOffer.languages);
    expect(viewModel.driverLicences, detailedOffer.driverLicences);
  });

  test("getDetails when state is incomplete data should set display state properly and convert data to view model", () {
    // Given
    final offreEmploi = mockOffreEmploi();
    final store =
        givenState().loggedInPoleEmploiUser().offreEmploiDetailsIncompleteData(offreEmploi: offreEmploi).store();

    // When
    final viewModel = OffreEmploiDetailsPageViewModel.create(store);

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

  group("shouldShowCvBottomSheet", () {
    test("is false with Milo account", () {
      // Given
      final store = givenState().loggedInMiloUser().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = OffreEmploiDetailsPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowCvBottomSheet, false);
    });

    test("is true with PoleEmploi account", () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().offreEmploiDetailsSuccess().store();

      // When
      final viewModel = OffreEmploiDetailsPageViewModel.create(store);

      // Then
      expect(viewModel.shouldShowCvBottomSheet, true);
    });
  });
}
