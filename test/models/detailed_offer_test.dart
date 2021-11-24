import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';

import '../utils/test_assets.dart';

main() {
  test('DetailedOffer.fromJson when complete data should deserialize data correctly', () {
    // Given
    final String detailedOfferString = loadTestAssets("detailed_offer.json");

    // When
    final detailedOfferJson = json.decode(detailedOfferString);

    // Then
    final expectedOffer = detailedOfferData();
    final test = DetailedOffer.fromJson(detailedOfferJson);
    expect(test, expectedOffer);
  });
}

DetailedOffer detailedOfferData() =>
    DetailedOffer(
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
      companyName: "LTD INTERNATIONAL",
      companyDescription: "LTD international est à la fois un cabinet de recrutement et une agence de travail "
          "temporaire spécialisé dans le tertiaire haut de gamme et le luxe.",
      companyUrl: "http://www.ltd-international.com/",
      companyAdapted: false,
      companyAccessibility: false,
      experience: "Débutant accepté - Expérience électricité/VRD appréciée",
      requiredExperience: "D",
      educations: [
        Education(level: null, field: "conduite projet industriel", requirement: "E")
      ],
      languages: [
        Language(type: "Anglais", requirement: "E"),
        Language(type: "Espagnol", requirement: "S")
      ],
      driverLicences: [
        DriverLicence(category: "B - Véhicule léger", requirement: "E"),
      ],
      skills: [
        Skill(description: "Chiffrage/calcul de coût", requirement: "S"),
        Skill(description: "Installer l'équipement sur le site et le connecter aux réseaux extérieurs", requirement: "E"),
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
    );