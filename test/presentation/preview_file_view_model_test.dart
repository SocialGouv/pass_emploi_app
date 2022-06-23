import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/preview_file_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {

  test('should not preview when not initialized', () {
    final store = givenState().previewFileNotInit().store();

    final viewModel = PreviewFileViewModel.create(store);

    expect(viewModel.path, null);
  });

  test('should preview file with path', () {
    final store = givenState().previewFile("path").store();

    final viewModel = PreviewFileViewModel.create(store);

    expect(viewModel.path, "path");
  });
}
