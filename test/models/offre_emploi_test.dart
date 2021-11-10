import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

import '../utils/test_assets.dart';

main() {
  test('OffreEmploi.fromJson when complete data should deserialize data correctly', () {
    // Given
    final String offresEmploiString = loadTestAssets("offres_emploi.json");

    // When
    final offresEmploiJson = json.decode(offresEmploiString);

    // Then
    final expectedOffres = offreEmploiData();
    for (int i = 0; i < expectedOffres.length; i++) {
      expect(OffreEmploi.fromJson(offresEmploiJson[i]), expectedOffres[i]);
    }
  });
}

List<OffreEmploi> offreEmploiData() => [
      OffreEmploi(
        id: "123DXPM",
        title: "Technicien / Technicienne en froid et climatisation",
        companyName: "RH TT INTERIM",
        contractType: "MIS",
        location: "77 - LOGNES",
      ),
      OffreEmploi(
        id: "123DXPK",
        title: " #SALONDEMANDELIEU2021: RECEPTIONNISTE TOURNANT (H/F)",
        companyName: "STAND CHATEAU DE LA BEGUDE",
        contractType: "CDD",
        location: "06 - OPIO",
      ),
      OffreEmploi(
        id: "123DXPG",
        title: "Technicien / Technicienne terrain Structure          (H/F)",
        companyName: "GEOTEC",
        contractType: "CDI",
        location: "78 - PLAISIR",
      ),
      OffreEmploi(
        id: "123DXPF",
        title: "Responsable de boutique",
        companyName: "GINGER",
        contractType: "CDD",
        location: "13 - AIX EN PROVENCE",
      ),
      OffreEmploi(
        id: "123DXLK",
        title: "Commercial sédentaire en Assurances H/F",
        companyName: null,
        contractType: "CDI",
        location: "34 - MONTPELLIER",
      )
    ];
