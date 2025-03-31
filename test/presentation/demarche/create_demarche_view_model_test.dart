import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when create demarche state is loading', () {
    // Given
    final store = givenState() //
        .loggedIn() //
        .searchDemarchesSuccess([(mockDemarcheDuReferentiel('id'))]) //
        .copyWith(createDemarcheState: CreateDemarcheLoadingState())
        .store();

    // When
    final viewModel = CreateDemarcheViewModel.create(store);

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
    final viewModel = CreateDemarcheViewModel.create(store);

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
    final viewModel = CreateDemarcheViewModel.create(store);

    // Then
    expect(viewModel.demarcheCreationState, isA<DemarcheCreationSuccessState>());
    expect((viewModel.demarcheCreationState as DemarcheCreationSuccessState).demarcheCreatedId, 'DEMARCHE-ID');
  });

  test('onSearchDemarche should trigger action', () {
    // Given
    final demarche = mockDemarcheDuReferentiel('id');
    final store = StoreSpy.withState(givenState().loggedIn().searchDemarchesSuccess([demarche]));
    final viewModel = CreateDemarcheViewModel.create(store);
    final now = DateTime.now();

    // When
    viewModel.onCreateDemarche(CreateDemarcheRequestAction(
      codeQuoi: 'codeQuoi',
      codePourquoi: 'codePourquoi',
      codeComment: 'codeComment',
      dateEcheance: now,
      estDuplicata: false,
    ));

    // Then
    expect(store.dispatchedAction, isA<CreateDemarcheRequestAction>());
  });
}
