import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when search state is not successful returns blank view model', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()) //
        .store();

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id');

    // Then
    expect(viewModel.quoi, isEmpty);
    expect(viewModel.pourquoi, isEmpty);
  });

  test('create when search state is successful but no demarche matches id returns blank view model', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .searchDemarchesSuccess([mockDemarcheDuReferentiel('id-0')]) //
        .store();

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id-1');

    // Then
    expect(viewModel.quoi, isEmpty);
    expect(viewModel.pourquoi, isEmpty);
  });

  test('create when search state is successful and demarche matches id', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        searchDemarcheState: SearchDemarcheSuccessState([mockDemarcheDuReferentiel('id')]),
      ),
    );

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 'id');

    // Then
    expect(viewModel.quoi, 'quoi');
    expect(viewModel.pourquoi, 'pourquoi');
  });
}
