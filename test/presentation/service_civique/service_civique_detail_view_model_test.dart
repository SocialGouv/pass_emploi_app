import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_detail_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create when state is loading should set display state to loading", () {
    // Given
    final state = AppState.initialState().copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueDetailViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when state is not initialized should set display state to loading", () {
    // Given
    final state =
        AppState.initialState().copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailNotInitializedState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueDetailViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when state is success should set display state to content", () {
    // Given
    final ServiceCiviqueDetail detail = mockServiceCiviqueDetail();
    final state = AppState.initialState().copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailSuccessState(detail));
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueDetailViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.detail, detail);
  });

  test("create when state is error should display un error", () {
    // Given
    final state = AppState.initialState().copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ServiceCiviqueDetailViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  group('shouldShowCvBottomSheet', () {
    test("is false with Milo account", () {
      // Given
      final store = givenState()
          .loggedInMiloUser()
          .copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailFailureState())
          .store();

      // When
      final viewModel = ServiceCiviqueDetailViewModel.create(store);

      // Then
      expect(viewModel.shouldShowCvBottomSheet, false);
    });

    test("is true with PoleEmploi account", () {
      // Given
      final store = givenState()
          .loggedInPoleEmploiUser()
          .copyWith(serviceCiviqueDetailState: ServiceCiviqueDetailFailureState())
          .store();

      // When
      final viewModel = ServiceCiviqueDetailViewModel.create(store);

      // Then
      expect(viewModel.shouldShowCvBottomSheet, true);
    });
  });
}
