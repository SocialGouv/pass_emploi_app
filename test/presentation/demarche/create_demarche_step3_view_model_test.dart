import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('when source is research', () {
    test('create when search state is not successful returns blank view model', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()) //
          .store();

      // When
      final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

      // Then
      expect(viewModel.pourquoi, isEmpty);
      expect(viewModel.quoi, isEmpty);
    });

    test('create when search state is successful but no demarche matches id returns blank view model', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([mockDemarcheDuReferentiel('id-0')]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id-1', RechercheDemarcheSource());

      // Then
      expect(viewModel.pourquoi, isEmpty);
      expect(viewModel.quoi, isEmpty);
    });

    test('create when search state is successful and demarche matches id', () {
      // Given
      final demarche = mockDemarcheDuReferentiel('id');
      final store = givenState() //
          .loggedIn() //
          .searchDemarchesSuccess([demarche]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

      // Then
      expect(viewModel.pourquoi, demarche.pourquoi);
      expect(viewModel.quoi, demarche.quoi);
    });
  });

  group('when source is thematique', () {
    test('create when thematique state is successful and demarche matches id', () {
      // Given
      final demarche = mockDemarcheDuReferentiel('id');

      final store = givenState() //
          .loggedIn() //
          .withThematiqueDemarcheSuccessState(demarches: [demarche]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', ThematiqueDemarcheSource("P03"));

      // Then
      expect(viewModel.pourquoi, demarche.pourquoi);
      expect(viewModel.quoi, demarche.quoi);
    });
  });

  group('when source is top demarche', () {
    test('create when thematique state is successful and demarche matches id', () {
      // Given
      final demarche = mockDemarcheDuReferentiel('id');

      final store = givenState() //
          .loggedIn() //
          .withTopDemarcheSuccessState(demarches: [demarche]) //
          .store();

      // When
      final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', TopDemarcheSource());

      // Then
      expect(viewModel.pourquoi, demarche.pourquoi);
      expect(viewModel.quoi, demarche.quoi);
    });
  });

  test('create when demarche has no comment', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id', []);
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([demarche]) //
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.pourquoi, demarche.pourquoi);
    expect(viewModel.quoi, demarche.quoi);
    expect(viewModel.comments, isEmpty);
  });

  test('create when demarche has only one comment should display it as Text and not display comment as mandatory', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id', [Comment(label: 'label1', code: 'code1')]);
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([demarche]) //
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.pourquoi, demarche.pourquoi);
    expect(viewModel.quoi, demarche.quoi);
    expect(viewModel.comments, [CommentTextItem(label: 'label1', code: 'code1')]);
    expect(viewModel.isCommentMandatory, isFalse);
  });

  test('create when demarche has several comments should display them as RadioButton', () {
    // Given
    final demarche = mockDemarcheDuReferentiel(
      'id',
      [Comment(label: 'label1', code: 'code1'), Comment(label: 'label2', code: 'code2')],
    );
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([demarche]) //
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.pourquoi, demarche.pourquoi);
    expect(viewModel.quoi, demarche.quoi);
    expect(
      viewModel.comments,
      [CommentRadioButtonItem(label: 'label1', code: 'code1'), CommentRadioButtonItem(label: 'label2', code: 'code2')],
    );
  });

  test('create when comment is mandatory', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id');
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([demarche]) //
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.isCommentMandatory, demarche.isCommentMandatory);
  });

  test('create when create demarche state is loading', () {
    // Given
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([(mockDemarcheDuReferentiel('id'))]) //
        .copyWith(createDemarcheState: CreateDemarcheLoadingState())
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when create demarche state is failure', () {
    // Given
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([(mockDemarcheDuReferentiel('id'))]) //
        .copyWith(createDemarcheState: CreateDemarcheFailureState())
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('create when create demarche state is success should go back to demarches list', () {
    // Given
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([(mockDemarcheDuReferentiel('id'))]) //
        .copyWith(createDemarcheState: CreateDemarcheSuccessState('DEMARCHE-ID'))
        .store();

    // When
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());

    // Then
    expect(viewModel.demarcheCreationState, isA<DemarcheCreationSuccessState>());
    expect((viewModel.demarcheCreationState as DemarcheCreationSuccessState).demarcheCreatedId, 'DEMARCHE-ID');
  });

  test('onSearchDemarche should trigger action', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id');
    final store = StoreSpy.withState(givenState().loggedIn().searchDemarchesSuccess([demarche]));
    final viewModel = CreateDemarcheStep3ViewModel.create(store, 'id', RechercheDemarcheSource());
    final now = DateTime.now();

    // When
    viewModel.onCreateDemarche('codeComment', now);

    // Then
    expect(store.dispatchedAction, isA<CreateDemarcheRequestAction>());
    final action = store.dispatchedAction as CreateDemarcheRequestAction;
    expect(action.codeQuoi, 'codeQuoi');
    expect(action.codePourquoi, 'codePourquoi');
    expect(action.codeComment, 'codeComment');
    expect(action.dateEcheance, now);
  });
}
