import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/solutions_tabs_page_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test('create should set proper tabs', () {
    // Given
    final store = givenState().loggedInPoleEmploiUser().store();

    // When
    final viewModel = SolutionsTabPageViewModel.create(store);

    // Then
    expect(viewModel.tabs, [SolutionsTab.recherche, SolutionsTab.offresEnregistrees, SolutionsTab.outils]);
  });
}
