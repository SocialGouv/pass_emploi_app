import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_bottom_sheet_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('should display CancelButton when status possibles contains cancel', () {
    // Given
    final demarche = mockDemarche(id: "8802034", possibleStatus: [DemarcheStatus.CANCELLED]);
    final store = givenState().withDemarches([demarche]).store();

    // When
    final viewModel = DemarcheDetailBottomSheetViewModel.create(store, "8802034");

    // Then
    expect(viewModel.withDemarcheCancelButton, isTrue);
  });

  test('DemarcheStatus should dispatch UpdateDemarcheRequestAction with canceled status', () {
    // Given
    final store = StoreSpy.withState(givenState().withDemarches(mockDemarches()));

    final viewModel = DemarcheDetailBottomSheetViewModel.create(store, "demarcheId");

    // When
    viewModel.onDemarcheCancel();

    // Then
    expect(
        store.dispatchedAction,
        isA<UpdateDemarcheRequestAction>().having(
          (action) => action.status,
          "status",
          DemarcheStatus.CANCELLED,
        ));
  });
}
