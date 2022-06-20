import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step2_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when state is successful without result should only display specific title and button', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(searchDemarcheState: SearchDemarcheSuccessState([])),
    );

    // When
    final viewModel = CreateDemarcheStep2ViewModel.create(store);

    // Then
    expect(viewModel.items.length, 2);

    expect(viewModel.items[0], isA<CreateDemarcheStep2TitleItem>());
    expect(
      (viewModel.items[0] as CreateDemarcheStep2TitleItem).title,
      'Aucune démarche pre-renseignée n’a été trouvée',
    );

    expect(viewModel.items[1], isA<CreateDemarcheStep2ButtonItem>());
  });

  test('create when state is successful with result should display specific title, items and button', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        searchDemarcheState: SearchDemarcheSuccessState([
          mockDemarcheDuReferentiel('quoi-1'),
          mockDemarcheDuReferentiel('quoi-2'),
        ]),
      ),
    );

    // When
    final viewModel = CreateDemarcheStep2ViewModel.create(store);

    // Then
    expect(viewModel.items.length, 4);

    expect(viewModel.items[0], isA<CreateDemarcheStep2TitleItem>());
    expect(
      (viewModel.items[0] as CreateDemarcheStep2TitleItem).title,
      'Sélectionnez une démarche ou créez une démarche personnalisée',
    );

    expect(viewModel.items[1], isA<CreateDemarcheStep2DemarcheFoundItem>());
    expect((viewModel.items[1] as CreateDemarcheStep2DemarcheFoundItem).indexOfDemarche, 0);

    expect(viewModel.items[2], isA<CreateDemarcheStep2DemarcheFoundItem>());
    expect((viewModel.items[2] as CreateDemarcheStep2DemarcheFoundItem).indexOfDemarche, 1);

    expect(viewModel.items[3], isA<CreateDemarcheStep2ButtonItem>());
  });
}
