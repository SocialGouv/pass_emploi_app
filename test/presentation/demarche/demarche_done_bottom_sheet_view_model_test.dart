import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_done_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group("update display state ...", () {
    test("is empty when UpdateDemarcheState is not initialized", () {
      // Given
      final store = givenState().updateDemarcheNotInit().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDoneBottomSheetViewModel.create(store, "demarcheId");

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });

    test("is loading when UpdateDemarcheState is loading", () {
      // Given
      final store = givenState().updateDemarcheLoading().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDoneBottomSheetViewModel.create(store, "demarcheId");

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test("is empty when UpdateDemarcheState succeeds", () {
      // Given
      final store = givenState().updateDemarcheSuccess().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDoneBottomSheetViewModel.create(store, "demarcheId");

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test("is failure when UpdateDemarcheState failed", () {
      // Given
      final store = givenState().updateDemarcheFailure().withDemarches(mockDemarches()).store();

      // When
      final viewModel = DemarcheDoneBottomSheetViewModel.create(store, "demarcheId");

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  });

  test('should dispatch UpdateDemarcheRequestAction with done status', () {
    // Given
    final store = StoreSpy.withState(givenState().withDemarches(mockDemarches()));

    final viewModel = DemarcheDoneBottomSheetViewModel.create(store, "demarcheId");

    // When
    viewModel.onDemarcheDone(DateTime(2025));

    // Then
    expect(
        store.dispatchedAction,
        isA<UpdateDemarcheRequestAction>().having(
          (action) => action.status,
          "status",
          DemarcheStatus.DONE,
        ));
  });
}
