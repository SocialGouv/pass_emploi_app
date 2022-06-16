import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/share_sheet_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {

  test('should not share when not initialized', () {
    final store = givenState().shareSheetNotInit().store();

    final viewModel = ShareSheetViewModel.create(store);

    expect(viewModel.path, null);
  });

  test('should share path when success', () {
    final store = givenState().shareSheet("path").store();

    final viewModel = ShareSheetViewModel.create(store);

    expect(viewModel.path, "path");
  });
}
