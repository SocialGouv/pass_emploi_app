import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/models/MonConseillerInfo.dart';
import 'package:pass_emploi_app/presentation/profil_page_view_model.dart';

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
    expect(viewModel.displayState, ConseillerProfilePageViewModelDisplayStateLoading());
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
    expect(viewModel.displayState,
        ConseillerProfilePageViewModelDisplayStateContent(sinceDate: "Depuis le 03/01/05", name: "Alexandre Astier"));
  });

  test('should be hidden (for failure)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerFailureState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, ConseillerProfilePageViewModelDisplayStateHidden());
  });

  test('should be hidden (at initialization)', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(conseillerState: ConseillerNotInitializedState()),
    );

    // When
    final viewModel = ConseillerProfilePageViewModel.create(store);

    // Then
    expect(viewModel.displayState, ConseillerProfilePageViewModelDisplayStateHidden());
  });
}
