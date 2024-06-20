import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('when source is recherche', () {
    test('create when search state is not successful returns blank view model', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()) //
          .store();

      // When
      final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id', RechercheDemarcheSource());

      // Then
      expect(viewModel.quoi, isEmpty);
      expect(viewModel.pourquoi, isEmpty);
    });

    test('create when search state is successful but no demarche matches id returns blank view model', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([mockDemarcheDuReferentiel('id-0')]) //
          .store();

      // When
      final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id-1', RechercheDemarcheSource());

      // Then
      expect(viewModel.quoi, isEmpty);
      expect(viewModel.pourquoi, isEmpty);
    });

    test('create when search state is successful and demarche matches id', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([mockDemarcheDuReferentiel('id')]) //
          .store();

      // When
      final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id', RechercheDemarcheSource());

      // Then
      expect(viewModel.quoi, 'quoi');
      expect(viewModel.pourquoi, 'pourquoi');
    });
  });

  group('when source is thematique', () {
    test('create when thematique state is successful and demarche matches id', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .withThematiqueDemarcheSuccessState(demarches: [mockDemarcheDuReferentiel('id')]) //
          .store();

      // When
      final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id', ThematiqueDemarcheSource("P03"));

      // Then
      expect(viewModel.quoi, 'quoi');
      expect(viewModel.pourquoi, 'pourquoi');
    });
  });
}
