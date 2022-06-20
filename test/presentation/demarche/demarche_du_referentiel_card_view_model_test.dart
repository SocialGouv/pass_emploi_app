import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when search state is not successful return blank view model', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        searchDemarcheState: SearchDemarcheNotInitializedState(),
      ),
    );

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 0);

    // Then
    expect(viewModel.quoi, isEmpty);
    expect(viewModel.pourquoi, isEmpty);
  });

  test('create when search state is successful but index does not exist return blank view model', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        searchDemarcheState: SearchDemarcheSuccessState([mockDemarcheDuReferentiel('quoi-1')]),
      ),
    );

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 1);

    // Then
    expect(viewModel.quoi, isEmpty);
    expect(viewModel.pourquoi, isEmpty);
  });

  test('create when search state is successful and index exists return', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        searchDemarcheState: SearchDemarcheSuccessState([mockDemarcheDuReferentiel('quoi-1')]),
      ),
    );

    // When
    final viewModel = DemarcheDuReferentielCardViewModel.create(store, 0);

    // Then
    expect(viewModel.quoi, 'quoi-1');
    expect(viewModel.pourquoi, 'pourquoi');
  });
}
