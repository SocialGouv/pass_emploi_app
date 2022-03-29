import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/models/MonConseillerInfo.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/conseiller_profil_page_view_model.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerLoadingState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('should display content', () {
    // Given
    final info = MonConseillerInfo(sinceDate: "03/01/05", firstname: "Alexandre", lastname: "Astier");
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerSuccessState(conseillerInfo: info)),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.sinceDate, "Depuis le 03/01/05");
    expect(viewModel.name, "Alexandre Astier");
  });

  test('should be hidden (for failure)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerFailureState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });

  test('should be hidden (at initialization)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerNotInitializedState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
  });
}
