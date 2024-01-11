import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_list_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("Quand les actions sont récupérées, afficher les actions en cours, puis les actions terminées et annulées", () {
    // Given
    final store = givenState() //
        .loggedInUser()
        .withUserActions(
      [
        mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
        mockUserAction(id: 'CANCELED', status: UserActionStatus.CANCELED),
        mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
        mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
        mockUserAction(id: 'NOT_STARTED', status: UserActionStatus.NOT_STARTED),
        mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
        mockUserAction(id: 'NOT_STARTED', status: UserActionStatus.NOT_STARTED),
        mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
        mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
      ],
    ).store();

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 9);
    for (var i = 0; i < 5; ++i) {
      expect((viewModel.items[i] as IdItem).userActionId, isIn(['IN_PROGRESS', 'NOT_STARTED']));
    }
    for (var i = 5; i < 9; ++i) {
      expect((viewModel.items[i] as IdItem).userActionId, isIn(['DONE', 'CANCELED']));
    }
  });
}
