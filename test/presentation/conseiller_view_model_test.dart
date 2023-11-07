import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/conseiller_profil_page_view_model.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: LoadingState()),
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
        detailsJeuneState: SuccessState<DetailsJeune>(detailsJeune()),
      ),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.sinceDate, "Depuis le 03/01/2005");
    expect(viewModel.name, "Perceval de Galles");
  });

  test('should be hidden (for failure)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: FailureState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test('should be hidden (at initialization)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(detailsJeuneState: NotInitializedState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });
}
