import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/conseiller_profil_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: DetailsJeuneLoadingState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('should display content', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        detailsJeuneState: DetailsJeuneSuccessState(detailsJeune: detailsJeune()),
      ),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.sinceDate, "Depuis le 03/01/2005");
    expect(viewModel.sinceDateA11y, "Depuis le 3 janvier 2005");
    expect(viewModel.name, "Perceval de Galles");
  });

  test('should be hidden (for failure)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: DetailsJeuneFailureState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test('should be hidden (at initialization)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: DetailsJeuneNotInitializedState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });
}
