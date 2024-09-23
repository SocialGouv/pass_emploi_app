import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/boite_a_outils_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test('create when accompagnement is CEJ', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.cej).store();

    // When
    final viewModel = BoiteAOutilsViewModel.create(store);

    // Then
    expect(viewModel.outils, [
      Outil.mesAidesFt,
      Outil.benevolatCej,
      Outil.formation,
      Outil.mentor,
      Outil.evenement,
      Outil.emploiStore,
      Outil.emploiSolidaire,
      Outil.laBonneBoite,
      Outil.alternance,
      Outil.diagoriente,
      Outil.mesAides1J1S,
    ]);
  });

  test('create when accompagnement is AIJ', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.aij).store();

    // When
    final viewModel = BoiteAOutilsViewModel.create(store);

    // Then
    expect(viewModel.outils, [
      Outil.mesAidesFt,
      Outil.benevolatPassEmploi,
      Outil.formation,
      Outil.mentor,
      Outil.evenement,
      Outil.emploiStore,
      Outil.emploiSolidaire,
      Outil.laBonneBoite,
      Outil.alternance,
      Outil.diagoriente,
      Outil.mesAides1J1S,
    ]);
  });

  test('create when accompagnement is RSA', () {
    // Given
    final store = givenState().loggedInUser(accompagnement: Accompagnement.rsaFranceTravail).store();

    // When
    final viewModel = BoiteAOutilsViewModel.create(store);

    // Then
    expect(viewModel.outils, [
      Outil.mesAidesFt,
      Outil.benevolatPassEmploi,
      Outil.emploiStore,
      Outil.emploiSolidaire,
      Outil.laBonneBoite,
      Outil.mesAides1J1S,
    ]);
  });
}