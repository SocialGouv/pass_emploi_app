import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_dto.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/presentation/derniere_offre_consultee_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('should create when derniere offre consultee is offre emploi', () {
    // Given
    final offreEmploi = OffreEmploiDto(mockOffreEmploi());
    final store = givenState().withDerniereOffreEnregistree(offreEmploi).store();

    // When
    final viewModel = DerniereOffreConsulteeViewModel.create(store);

    // Then
    expect(viewModel.id, offreEmploi.offreEmploi.id);
    expect(viewModel.titre, offreEmploi.offreEmploi.title);
    expect(viewModel.organisation, offreEmploi.offreEmploi.companyName);
    expect(viewModel.type, OffreType.emploi);
    expect(viewModel.localisation, offreEmploi.offreEmploi.location);
  });

  test('when derniere offre consultee is immersion', () {
    // Given
    final offreImmersion = OffreImmersionDto(mockImmersion());
    final store = givenState().withDerniereOffreEnregistree(offreImmersion).store();

    // When
    final viewModel = DerniereOffreConsulteeViewModel.create(store);

    // Then
    expect(viewModel.id, offreImmersion.immersion.id);
    expect(viewModel.titre, offreImmersion.immersion.metier);
    expect(viewModel.organisation, offreImmersion.immersion.nomEtablissement);
    expect(viewModel.type, OffreType.immersion);
    expect(viewModel.localisation, offreImmersion.immersion.ville);
  });

  test('when derniere offre consultee is service civique', () {
    // Given
    final offreServiceCivique = OffreServiceCiviqueDto(mockServiceCivique());
    final store = givenState().withDerniereOffreEnregistree(offreServiceCivique).store();

    // When
    final viewModel = DerniereOffreConsulteeViewModel.create(store);

    // Then
    expect(viewModel.id, offreServiceCivique.serviceCivique.id);
    expect(viewModel.titre, offreServiceCivique.serviceCivique.title);
    expect(viewModel.organisation, offreServiceCivique.serviceCivique.companyName);
    expect(viewModel.type, OffreType.serviceCivique);
    expect(viewModel.localisation, offreServiceCivique.serviceCivique.location);
  });
}
