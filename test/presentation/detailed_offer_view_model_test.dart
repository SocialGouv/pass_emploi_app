import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/detailed_offer_state.dart';
import 'package:redux/redux.dart';

import '../models/detailed_offer_test.dart';

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
    final viewModel = OffreEmploiListViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_LOADER);
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
    final viewModel = OffreEmploiListViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("getDetails when state is success should set display state properly and convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        detailedOfferState: DetailedOfferState.success(detailedOfferData()),
      ),
    );

    // When
    final viewModel = OffreEmploiListViewModel.getDetails(store);

    // Then
    expect(viewModel.displayState, OffreEmploiListDisplayState.SHOW_DETAILS);
    expect(viewModel.detailedOffer, DetailedOffer(
      id: "123TZKB",
      title: "Technicien / Technicienne d'installation de réseaux câblés  (H/F)",
      offerDescription: "Vos Missions :\n\nRéaliser du tirage de câbles,\n"
          "Effectuer des raccordements en fibre optique et câble coaxial,\n\n"
          "Le permis B est requis pour ce poste car vous vous déplacerez à bord "
          "d'un véhicule de service mis à votre disposition.",
      contractType: "Contrat à durée indéterminée",
      duration: "35H Horaires normaux",
      location: "59 - Nord",
      salary: "Mensuel de 1590 Euros sur 12 mois",
      companyName: "POLE EMPLOI",
      companyDescription: null,
      companyUrl: null,
      companyAdapted: false,
      companyAccessibility: false,
      experience: "Débutant accepté - Expérience électricité/VRD appréciée",
      requiredExperience: "D",
      education: null,
      language: [],
      driverLicence: [
        DriverLicence(category: "B - Véhicule léger", requirement: "E"),
      ],
      skills: [
        Skill(description: "Chiffrage/calcul de coût", requirement: "S"),
        Skill(
            description: "Installer l'équipement sur le site et le connecter aux réseaux extérieurs", requirement: "E"),
        Skill(description: "Identifier les matériels à intégrer", requirement: "E"),
        Skill(description: "Assembler les éléments de l'équipement", requirement: "E"),
        Skill(description: "Connecter une boîte de raccordements", requirement: "E")
      ],
      softSkills: [
        SoftSkill(description: "Autonomie"),
        SoftSkill(description: "Capacité de décision"),
        SoftSkill(description: "Persévérance")
      ],
      lastUpdate: "2021-11-22T14:47:29.000Z",
    )
    );
  });
}
