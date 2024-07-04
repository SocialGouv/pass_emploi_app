import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/matching_demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/duplicate_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('DuplicateDemarcheViewModel', () {
    test('when cannot find demarche should display empty view model', () {
      // Given
      final store = givenState() //
          .store();

      // When
      final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

      // Then
      expect(
        viewModel,
        DuplicateDemarcheViewModel(
          demarcheId: "",
          displayState: DisplayState.EMPTY,
          sourceViewModel: DuplicateDemarcheNotInitializedViewModel(),
          onRetry: () {},
        ),
      );
    });

    group('display state', () {
      test("create thematique state is not initialized should display loading", () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withThematiqueDemarcheNotInitializedState()
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test("create thematique state is loading should display loading", () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withThematiqueDemarcheLoadingState()
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.LOADING);
      });

      test("create thematique state is failure should display failure", () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withThematiqueDemarcheFailureState()
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.FAILURE);
      });

      test("create thematique state is success should display content", () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withThematiqueDemarcheSuccessState()
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.displayState, DisplayState.CONTENT);
      });
    });

    group('source view model', () {
      test('when matching demarche state is not success should display not initialized source', () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withMatchingDemarcheFailureState()
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.sourceViewModel, DuplicateDemarcheNotInitializedViewModel());
      });

      test('when demarche in not found in referentiel should display demarche personnalisee', () {
        // Given
        final store = givenState() //
            .withDemarches([mockDemarche(id: 'id')])
            .withMatchingDemarcheSuccessState(null)
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(viewModel.sourceViewModel, DuplicateDemarchePersonnaliseeViewModel());
      });

      test('when demarche is found in referentiel should display demarche du referentiel', () {
        // Given
        final comment = Comment(label: 'label1', code: 'code1');
        final demarcheDuReferentiel = mockDemarcheDuReferentiel('id', [comment]);
        final store = givenState() //
            .withDemarches([
              mockDemarche(
                id: 'id',
                titre: demarcheDuReferentiel.quoi,
                sousTitre: comment.label,
              )
            ])
            .withMatchingDemarcheSuccessState(MatchingDemarcheDuReferentiel(
              thematique: dummyThematiqueDeDemarche(),
              demarcheDuReferentiel: demarcheDuReferentiel,
              comment: comment,
            ))
            .store();

        // When
        final viewModel = DuplicateDemarcheViewModel.create(store, 'id');

        // Then
        expect(
            viewModel.sourceViewModel,
            DuplicateDemarcheDuReferentielViewModel(
              thematiqueCode: dummyThematiqueDeDemarche().code,
              demarcheDuReferentielId: demarcheDuReferentiel.id,
              commentCode: comment.code,
            ));
      });
    });
  });
}
